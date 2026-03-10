local M = {}

local registry = {}

local function modes(mode)
    if type(mode) == "table" then
        return mode
    end

    return { mode }
end

local function caller()
    local level = 2

    while true do
        local info = debug.getinfo(level, "Sl")
        if not info then
            return "unknown:0"
        end

        local source = info.short_src or info.source or "unknown"
        if not source:match("util[/\\]keymap%.lua$") then
            return string.format("%s:%d", source, info.currentline or 0)
        end

        level = level + 1
    end
end

local function register(mode, lhs, opts)
    if opts.override then
        return
    end

    local key = string.format("%s\31%s", mode, lhs)
    local source = caller()
    local existing = registry[key]

    if existing and existing.source ~= source then
        error(string.format("Duplicate keymap for mode '%s': %s (first at %s, redefined at %s)", mode, lhs, existing.source, source))
    end

    registry[key] = existing or {
        source = source,
    }
end

function M.set(mode, lhs, rhs, opts)
    local map_opts = vim.tbl_extend("force", {}, opts or {})
    local override = map_opts.override or false
    map_opts.override = nil

    for _, current_mode in ipairs(modes(mode)) do
        register(current_mode, lhs, { override = override })
    end

    vim.keymap.set(mode, lhs, rhs, map_opts)
end

return M
