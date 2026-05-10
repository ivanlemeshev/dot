-- Lua sample for keywords, functions, strings, and numbers.

local app_name = "theme-sample"

local function greet(name)
	name = name or "world"
	print(("hello %s"):format(name))
end

for _, item in ipairs({ "one", "two", "three" }) do
	if item == "two" then
		greet(item)
	else
		print(item)
	end
end

greet(app_name)
