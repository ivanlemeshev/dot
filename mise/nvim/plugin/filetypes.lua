local extensions = {
  rkt = "racket",
  rktd = "racket",
  rktl = "racket",
}

if vim.fn.has("win32") ~= 1 then
  local function ansible_yaml_filetype(path)
    local normalized = vim.fs.normalize(path)

    if normalized:match("/ansible/") or normalized:match("/playbooks/") then
      return "yaml.ansible"
    end
    if normalized:match("/roles/.+/(tasks|handlers|vars|defaults|meta)/") then
      return "yaml.ansible"
    end
    if normalized:match("/group_vars/") or normalized:match("/host_vars/") then
      return "yaml.ansible"
    end

    return "yaml"
  end

  extensions.yml = ansible_yaml_filetype
  extensions.yaml = ansible_yaml_filetype
end

vim.filetype.add({ extension = extensions })
