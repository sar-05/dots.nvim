-- Require all lua modules of the plugins submodule
local config_path = vim.fn.stdpath 'config'
local plugin_path = config_path .. '/lua/plugins'

local files = vim.fs.find(function(name)
  return name:match '%.lua$'
end, { path = plugin_path, limit = math.huge })

-- Parse priority
local sorted = {}

for _, filepath in ipairs(files) do
  local name = vim.fs.basename(filepath)

  if name ~= 'init.lua' then
    local modname = name:gsub('%.lua$', '')
    local priority = tonumber(modname:match '^([0-9]+)_')

    -- if no leading number, priority = nil
    table.insert(sorted, {
      priority = priority,
      name = modname,
    })
  end
end

-- Sort by priority
table.sort(sorted, function(a, b)
  if a.priority and b.priority then
    return a.priority < b.priority
  elseif a.priority then
    return true
  elseif b.priority then
    return false
  else
    return a.name < b.name
  end
end)

-- Require modules
for _, entry in ipairs(sorted) do
  require('plugins.' .. entry.name)
end
