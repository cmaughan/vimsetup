local M = {}

function M.environment()
    -- Keep machine-specific connection settings out of the shared configuration.
    local path = vim.fn.stdpath('config') .. '/perforce-local.json'
    if vim.fn.filereadable(path) == 1 then
        local settings = vim.json.decode(table.concat(vim.fn.readfile(path), '\n'))
        vim.env.P4PORT = vim.env.P4PORT or settings.port
        vim.env.P4CLIENT = vim.env.P4CLIENT or settings.client
    end
end

function M.setup()
    -- Query the effective client without a shell; this also preserves roots
    -- containing spaces and honors P4CONFIG and the local defaults above.
    local client = require('nvim-p4.client')
    local function set_client(name)
        local cmd = { 'p4', '-ztag', '-Mj' }
        if name then vim.list_extend(cmd, { '-c', name }) end
        table.insert(cmd, 'info')
        local result = vim.system(cmd, { text = true, timeout = 10000 }):wait()
        if result.code ~= 0 then
            vim.notify('Perforce connection failed; check p4 info/login', vim.log.levels.ERROR)
            return
        end
        local info = vim.json.decode((result.stdout or ''):match('[^\r\n]+') or '{}')
        client.name = info.clientName
        client.root = info.clientRoot
    end
    client.set_client = set_client
    client.bootstrap = function() set_client() end
    require('nvim-p4').setup({})
    -- Upstream parses shell-formatted fstat output; use tagged JSON so Windows
    -- paths, spaces, and added files retain their metadata.
    require('nvim-p4.p4').fstat = function(depot_files)
        if #depot_files == 0 then return {} end
        local cmd = { 'p4', '-ztag', '-Mj', '-c', client.name, 'fstat', '-T',
            'depotFile,path,headRev,type,workRev,haveRev,action,unresolved', '-Op' }
        vim.list_extend(cmd, depot_files)
        local result = vim.system(cmd, { text = true, timeout = 10000 }):wait()
        if result.code ~= 0 then
            vim.notify('Perforce file metadata query failed', vim.log.levels.ERROR)
            return {}
        end
        local files = {}
        for line in (result.stdout or ''):gmatch('[^\r\n]+') do
            local row = vim.json.decode(line)
            if row.depotFile and row.path and row.action ~= 'delete' and row.action ~= 'move/delete' then
                row.headRev = tonumber(row.headRev)
                row.workRev = tonumber(row.workRev) or tonumber(row.haveRev) or 0
                row.haveRev = tonumber(row.haveRev)
                table.insert(files, row)
            end
        end
        return files
    end
end

return M
