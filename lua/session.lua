local paths = require("util.paths")

local M = {}

local SESSION_DIR = paths.ensure_dir(vim.fn.stdpath("state") .. "/sessions")
local SESSION_OPTIONS = {
    "buffers",
    "curdir",
    "folds",
    "skiprtp",
    "tabpages",
    "winsize",
}

local IGNORED_BUFTYPES = {
    help = true,
    nofile = true,
    prompt = true,
    quickfix = true,
    terminal = true,
}

local IGNORED_FILETYPES = {
    TelescopePrompt = true,
    lazy = true,
    mason = true,
    minifiles = true,
    qf = true,
}

local function notify(message, level, opts)
    if opts and opts.silent then
        return
    end

    vim.notify(message, level or vim.log.levels.INFO, { title = "Session" })
end

local function normalize(path)
    return vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
end

local function current_dir()
    return normalize(vim.uv.cwd() or vim.fn.getcwd())
end

local function git_root(path)
    if vim.fn.executable("git") ~= 1 then
        return nil
    end

    local output = vim.fn.systemlist({ "git", "-C", path, "rev-parse", "--show-toplevel" })
    if vim.v.shell_error ~= 0 then
        return nil
    end

    local root = output[1]
    if not root or root == "" then
        return nil
    end

    return normalize(root)
end

local function project_name(root)
    local name = vim.fn.fnamemodify(root, ":t")
    if name == "" then
        name = "session"
    end

    return name:gsub("[^%w%-_]", "_")
end

local function session_name(root)
    return string.format("%s-%s.vim", project_name(root), vim.fn.sha256(root):sub(1, 12))
end

local function with_sessionoptions(callback)
    local previous = vim.opt.sessionoptions:get()
    vim.opt.sessionoptions = SESSION_OPTIONS

    local ok, result = pcall(callback)
    vim.opt.sessionoptions = previous

    return ok, result
end

local function is_empty_buffer(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) then
        return false
    end

    if vim.api.nvim_buf_get_name(bufnr) ~= "" or vim.bo[bufnr].modified or vim.bo[bufnr].buftype ~= "" then
        return false
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    return #lines <= 1 and (lines[1] == nil or lines[1] == "")
end

local function is_transient_buffer(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) then
        return false
    end

    if IGNORED_BUFTYPES[vim.bo[bufnr].buftype] then
        return true
    end

    if IGNORED_FILETYPES[vim.bo[bufnr].filetype] then
        return true
    end

    return is_empty_buffer(bufnr)
end

local function has_modified_buffers()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].modified then
            return true
        end
    end

    return false
end

local function prune_transient_state()
    local windows = vim.api.nvim_list_wins()

    for _, win in ipairs(windows) do
        if vim.api.nvim_win_is_valid(win) then
            local bufnr = vim.api.nvim_win_get_buf(win)
            if is_transient_buffer(bufnr) and #vim.api.nvim_list_wins() > 1 then
                pcall(vim.api.nvim_win_close, win, true)
            end
        end
    end

    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(bufnr) and is_transient_buffer(bufnr) then
            pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
        end
    end
end

local function should_auto_restore()
    if #vim.api.nvim_list_uis() == 0 then
        return false
    end

    if vim.fn.argc() > 0 or vim.o.diff then
        return false
    end

    if vim.g.started_by_firenvim then
        return false
    end

    return true
end

function M.project_root()
    return git_root(current_dir()) or current_dir()
end

function M.session_path(root)
    root = normalize(root or M.project_root())
    return SESSION_DIR .. "/" .. session_name(root)
end

function M.save(opts)
    opts = opts or {}

    local path = M.session_path()
    local ok, result = with_sessionoptions(function()
        vim.cmd("silent! mksession! " .. vim.fn.fnameescape(path))
        return path
    end)

    if not ok then
        notify("Failed to save session: " .. tostring(result), vim.log.levels.ERROR, opts)
        return false
    end

    notify("Saved session: " .. result, vim.log.levels.INFO, opts)
    return true
end

function M.restore(opts)
    opts = opts or {}

    local path = M.session_path()
    if vim.fn.filereadable(path) ~= 1 then
        notify("No session for " .. M.project_root(), vim.log.levels.INFO, opts)
        return false
    end

    if not opts.force and has_modified_buffers() then
        notify("Modified buffers present. Use :SessionRestore! to force restore.", vim.log.levels.WARN, opts)
        return false
    end

    pcall(vim.cmd, "silent! tabonly")
    pcall(vim.cmd, "silent! only")
    pcall(vim.cmd, opts.force and "silent! %bwipeout!" or "silent! %bwipeout")

    local ok, err = pcall(vim.cmd, "silent! source " .. vim.fn.fnameescape(path))
    if not ok then
        notify("Failed to restore session: " .. tostring(err), vim.log.levels.ERROR, opts)
        return false
    end

    prune_transient_state()
    notify("Restored session: " .. path, vim.log.levels.INFO, opts)
    return true
end

function M.delete(opts)
    opts = opts or {}

    local path = M.session_path()
    if vim.fn.filereadable(path) ~= 1 then
        notify("No session to delete for " .. M.project_root(), vim.log.levels.INFO, opts)
        return false
    end

    if vim.fn.delete(path) ~= 0 then
        notify("Failed to delete session: " .. path, vim.log.levels.ERROR, opts)
        return false
    end

    pcall(function()
        vim.v.this_session = ""
    end)

    notify("Deleted session: " .. path, vim.log.levels.INFO, opts)
    return true
end

function M.setup()
    if M._setup_complete then
        return
    end

    M._setup_complete = true

    vim.api.nvim_create_user_command("SessionSave", function()
        M.save()
    end, { desc = "Save the current project session" })

    vim.api.nvim_create_user_command("SessionRestore", function(args)
        M.restore({ force = args.bang })
    end, { bang = true, desc = "Restore the current project session" })

    vim.api.nvim_create_user_command("SessionDelete", function()
        M.delete()
    end, { desc = "Delete the current project session" })

    local group = vim.api.nvim_create_augroup("UserProjectSessions", { clear = true })

    vim.api.nvim_create_autocmd("VimEnter", {
        group = group,
        once = true,
        callback = function()
            if should_auto_restore() then
                vim.schedule(function()
                    M.restore({ silent = true })
                end)
            end
        end,
    })

    vim.api.nvim_create_autocmd("VimLeavePre", {
        group = group,
        callback = function()
            if #vim.api.nvim_list_uis() > 0 then
                M.save({ silent = true })
            end
        end,
    })
end

return M
