local plugin_modules = {
  "plugins.lem",
  "plugins.icons",
  "plugins.essentials",
  "plugins.mason",
  "plugins.cmp",
  "plugins.lsp",
  -- "plugins.telescope",
  "plugins.search",
  "plugins.explorer",
  "plugins.git",
  "plugins.formatting",
  "plugins.linting",
  "plugins.mini.move",
  "plugins.indentation",
  "plugins.mini.splitjoin",
  "plugins.mini.hipatterns",
  "plugins.misc",
  "plugins.trouble",
  "plugins.http",
  "plugins.copilot",
  "plugins.statusline",
}

local function is_spec(value)
  return type(value) == "table"
    and (type(value[1]) == "string" or type(value.src) == "string" or type(value.dir) == "string")
end

local function as_list(value)
  if is_spec(value) then
    return { value }
  end

  if type(value) ~= "table" then
    return {}
  end

  return value
end

local function plugin_name(spec)
  if spec.name ~= nil then
    return spec.name
  end

  local src = spec.src or spec[1]
  if type(src) ~= "string" then
    return nil
  end

  local name = src:match("([^/]+)$")
  if name == nil then
    return nil
  end

  return (name:gsub("%.git$", ""))
end

local loaded_specs = {}
local pack_specs = {}
local seen_pack_specs = {}

local function collect(spec)
  if not is_spec(spec) then
    return
  end

  table.insert(loaded_specs, spec)

  local dependencies = spec.dependencies or spec.deps
  if type(dependencies) == "table" then
    for _, dependency in ipairs(dependencies) do
      collect(dependency)
    end
  end

  if type(spec.dir) == "string" then
    return
  end

  local src = spec.src or spec[1]
  if type(src) ~= "string" then
    return
  end

  if not src:match("^[%w.+-]+://") and not src:match("^git@") then
    src = "https://github.com/" .. src
  end

  local name = plugin_name(spec)
  if name == nil then
    return
  end

  if seen_pack_specs[name] then
    return
  end

  seen_pack_specs[name] = true
  table.insert(pack_specs, {
    src = src,
    name = name,
    version = spec.commit or spec.version or spec.branch or spec.tag,
  })
end

for _, module in ipairs(plugin_modules) do
  local ok, specs = pcall(require, module)
  if not ok then
    error(("Failed to load %s: %s"):format(module, specs))
  end

  for _, spec in ipairs(as_list(specs)) do
    collect(spec)
  end
end

vim.pack.add(pack_specs, {
  load = true,
  confirm = false,
})

local function spec_main(spec)
  if spec.main ~= nil then
    return spec.main
  end

  local name = plugin_name(spec)
  if name == nil then
    return nil
  end

  return (name:gsub("%.nvim$", ""):gsub("^nvim%-", ""))
end

local configured = setmetatable({}, { __mode = "k" })
local initialized = setmetatable({}, { __mode = "k" })

local function initialize(spec)
  if initialized[spec] then
    return
  end

  initialized[spec] = true

  if type(spec.init) == "function" then
    spec.init()
  end
end

local function configure(spec)
  if configured[spec] then
    return
  end

  initialize(spec)
  configured[spec] = true

  if type(spec.config) == "function" then
    spec.config(spec, spec.opts or {})
  elseif spec.opts ~= nil then
    local main = spec_main(spec)
    if main ~= nil then
      require(main).setup(spec.opts)
    end
  end

  if type(spec.keys) == "table" then
    for _, key in ipairs(spec.keys) do
      if type(key) == "table" and key[1] ~= nil and key[2] ~= nil then
        local rhs = key[2]
        vim.keymap.set(key.mode or "n", key[1], function()
          configure(spec)
          if type(rhs) == "string" then
            vim.cmd(rhs:gsub("^<cmd>", ""):gsub("<[cC][rR]>$", ""))
          elseif type(rhs) == "function" then
            rhs()
          end
        end, {
          desc = key.desc,
          silent = key.silent ~= false,
        })
      end
    end
  end
end

local function has_keymaps_without_rhs(spec)
  if type(spec.keys) ~= "table" then
    return false
  end

  for _, key in ipairs(spec.keys) do
    if type(key) == "table" and key[1] ~= nil and key[2] == nil then
      return true
    end
  end

  return false
end

local function setup_events(spec)
  local events = spec.event
  if type(events) == "string" then
    events = { events }
  end
  if type(events) ~= "table" then
    return false
  end

  for _, event in ipairs(events) do
    local autocmd_event = event == "VeryLazy" and "VimEnter" or event
    vim.api.nvim_create_autocmd(autocmd_event, {
      once = true,
      callback = function()
        configure(spec)
      end,
    })
  end

  return true
end

local function setup_filetypes(spec)
  local filetypes = spec.ft
  if type(filetypes) == "string" then
    filetypes = { filetypes }
  end
  if type(filetypes) ~= "table" then
    return false
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    once = true,
    callback = function()
      configure(spec)
    end,
  })

  return true
end

for _, spec in ipairs(loaded_specs) do
  initialize(spec)
end

for _, spec in ipairs(loaded_specs) do
  local has_events = setup_events(spec)
  local has_filetypes = setup_filetypes(spec)

  if spec.lazy == false or (not has_events and not has_filetypes) then
    configure(spec)
  elseif has_keymaps_without_rhs(spec) then
    configure(spec)
  elseif type(spec.keys) == "table" then
    configure(spec)
  end
end
