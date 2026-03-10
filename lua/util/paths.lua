local M = {}

local function join_paths(...)
  local parts = {}

  for _, part in ipairs({ ... }) do
    if part and part ~= "" then
      local normalized = tostring(part):gsub("\\", "/")
      normalized = normalized:gsub("/+$", "")
      table.insert(parts, normalized)
    end
  end

  return table.concat(parts, "/")
end

function M.ensure_dir(path)
  if path and path ~= "" and vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end

  return path
end

function M.dropbox_path(...)
  local root = vim.env.MYDROPBOX

  if not root or root == "" then
    return nil
  end

  return join_paths(root, ...)
end

function M.resolve_python_host_prog()
  if vim.fn.has("win32") == 1 then
    local pyenv_root = vim.env.PYENV_ROOT or vim.fn.expand("~/.pyenv/pyenv-win")
    local version_file = join_paths(pyenv_root, "version")

    if vim.fn.filereadable(version_file) == 1 then
      local versions = vim.fn.readfile(version_file)
      local active_version = versions[1]

      if active_version and active_version ~= "" then
        local candidate = join_paths(pyenv_root, "versions", active_version, "python.exe")
        if vim.fn.filereadable(candidate) == 1 then
          return candidate
        end
      end
    end

    local python = vim.fn.exepath("python")
    if python ~= "" then
      return python
    end
  end

  local python3 = vim.fn.exepath("python3")
  if python3 ~= "" then
    return python3
  end

  return nil
end

return M
