local M = {}

local MAX_BUILD_DEPTH = 3

local ignored_directories = {
    ['.cache'] = true,
    ['.git'] = true,
    ['.hg'] = true,
    ['.svn'] = true,
    ['.vscode'] = true,
    ['cmakefiles'] = true,
    ['_deps'] = true,
    ['deps'] = true,
    ['external'] = true,
    ['node_modules'] = true,
    ['third_party'] = true,
    ['third-party'] = true,
    ['vcpkg'] = true,
}

local cache = {}
local notified = {}

local function normalize(path)
    return vim.fs.normalize(path)
end

local function cache_key(path)
    path = normalize(path)
    return vim.fn.has('win32') == 1 and path:lower() or path
end

local function is_build_directory(name)
    local lower = name:lower()
    return lower:match('^build') ~= nil
        or lower:match('^cmake%-build') ~= nil
        or lower == 'out'
        or lower == 'target'
        or lower:find('ninja', 1, true) ~= nil
end

local function mtime(path)
    local stat = vim.uv.fs_stat(path)
    if not stat then
        return nil
    end

    return stat.mtime
end

local function is_newer(left, right)
    if not right then
        return true
    end
    if left.sec ~= right.sec then
        return left.sec > right.sec
    end
    return left.nsec > right.nsec
end

local function explicit_project_database(root)
    local path = vim.fs.joinpath(root, '.clangd')
    local file = io.open(path, 'r')
    if not file then
        return nil
    end

    local contents = file:read(64 * 1024) or ''
    file:close()

    if contents:match('[\r\n]?%s*CompilationDatabase%s*:') then
        return path
    end

    return nil
end

local function add_candidate(candidates, seen, database)
    local key = cache_key(database)
    if seen[key] then
        return
    end

    local database_time = mtime(database)
    if not database_time then
        return
    end

    seen[key] = true
    local directory = vim.fs.dirname(database)
    local ninja_log = vim.fs.joinpath(directory, '.ninja_log')
    local ninja_time = mtime(ninja_log)

    table.insert(candidates, {
        database = normalize(database),
        directory = normalize(directory),
        activity = ninja_time or database_time,
        activity_source = ninja_time and '.ninja_log' or 'compile_commands.json',
    })
end

local function scan_build_tree(path, depth, candidates, seen)
    local database = vim.fs.joinpath(path, 'compile_commands.json')
    add_candidate(candidates, seen, database)

    if depth >= MAX_BUILD_DEPTH then
        return
    end

    local handle = vim.uv.fs_scandir(path)
    if not handle then
        return
    end

    while true do
        local name, kind = vim.uv.fs_scandir_next(handle)
        if not name then
            break
        end

        if kind == 'directory' and not ignored_directories[name:lower()] then
            scan_build_tree(vim.fs.joinpath(path, name), depth + 1, candidates, seen)
        end
    end
end

local function find_candidates(root)
    local candidates = {}
    local seen = {}

    add_candidate(candidates, seen, vim.fs.joinpath(root, 'compile_commands.json'))

    local handle = vim.uv.fs_scandir(root)
    if not handle then
        return candidates
    end

    while true do
        local name, kind = vim.uv.fs_scandir_next(handle)
        if not name then
            break
        end

        if kind == 'directory' and not ignored_directories[name:lower()] and is_build_directory(name) then
            scan_build_tree(vim.fs.joinpath(root, name), 1, candidates, seen)
        end
    end

    return candidates
end

function M.select(root)
    if not root or root == '' then
        return nil
    end

    root = normalize(root)
    local key = cache_key(root)
    if cache[key] then
        return cache[key]
    end

    local started = vim.uv.hrtime()
    local project_config = explicit_project_database(root)
    if project_config then
        cache[key] = {
            root = root,
            project_config = normalize(project_config),
            scan_ms = (vim.uv.hrtime() - started) / 1e6,
        }
        return cache[key]
    end

    local candidates = find_candidates(root)
    local selected
    for _, candidate in ipairs(candidates) do
        if not selected or is_newer(candidate.activity, selected.activity) then
            selected = candidate
        end
    end

    local result = {
        root = root,
        candidate_count = #candidates,
        scan_ms = (vim.uv.hrtime() - started) / 1e6,
    }

    if selected then
        result.database = selected.database
        result.directory = selected.directory
        result.activity_source = selected.activity_source
        result.activity = selected.activity
    end

    cache[key] = result
    return result
end

function M.clear(root)
    if root and root ~= '' then
        local key = cache_key(root)
        cache[key] = nil
        notified[key] = nil
    else
        cache = {}
        notified = {}
    end
end

function M.notify_once(result)
    if not result then
        return
    end

    local key = cache_key(result.root)
    if notified[key] then
        return
    end
    notified[key] = true

    local level = (result.database or result.project_config)
        and vim.log.levels.INFO
        or vim.log.levels.WARN
    vim.schedule(function()
        vim.notify(M.describe(result), level)
    end)
end

function M.describe(result)
    if not result then
        return 'clangd: no project root found'
    end

    if result.project_config then
        return ('clangd: compilation database is controlled by %s'):format(result.project_config)
    end

    if not result.database then
        return ('clangd: no compilation database found under %s (%.2f ms)')
            :format(result.root, result.scan_ms)
    end

    return table.concat({
        ('clangd database: %s'):format(result.database),
        ('selected by: newest %s (%d candidate%s, %.2f ms)'):format(
            result.activity_source,
            result.candidate_count,
            result.candidate_count == 1 and '' or 's',
            result.scan_ms
        ),
    }, '\n')
end

return M
