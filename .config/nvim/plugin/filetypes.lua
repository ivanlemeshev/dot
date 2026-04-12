-- yaml, yaml.ansible
local function ansible_yaml_filetype(path)
  local normalized = vim.fs.normalize(path)

  if normalized:match("/ansible/") then
    return "yaml.ansible"
  end
  if normalized:match("/playbooks/") then
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

vim.filetype.add({
  extension = {
    yml = ansible_yaml_filetype,
    yaml = ansible_yaml_filetype,
  },
})
