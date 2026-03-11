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

local _dropbox_root_cache

local function get_dropbox_root()
  if _dropbox_root_cache ~= nil then return _dropbox_root_cache end
  local info_path
  if vim.fn.has("win32") == 1 then
    info_path = join_paths(vim.env.LOCALAPPDATA or "", "Dropbox/info.json")
  else
    info_path = vim.fn.expand("~/.dropbox/info.json")
  end

  if vim.fn.filereadable(info_path) == 1 then
    local ok, data = pcall(vim.fn.json_decode, table.concat(vim.fn.readfile(info_path), ""))
    if ok and data and data.personal and data.personal.path then
      _dropbox_root_cache = data.personal.path
      return _dropbox_root_cache
    end
  end

  _dropbox_root_cache = nil
  return nil
end

function M.dropbox_path(...)
  local root = get_dropbox_root()
  if not root or root == "" then
    return nil
  end
  return join_paths(root, ...)
end

function M.resolve_python_host_prog()
  -- Prefer the dedicated Neovim venv (has pynvim installed)
  local venv_python = vim.fn.has("win32") == 1
    and vim.fn.expand("~/AppData/Local/python-global/Scripts/python.exe")
    or  vim.fn.expand("~/.local/share/nvim-venv/bin/python")

  if vim.fn.filereadable(venv_python) == 1 then
    return venv_python
  end

  local python = vim.fn.exepath(vim.fn.has("win32") == 1 and "python" or "python3")
  if python ~= "" then return python end

  return nil
end

return M
