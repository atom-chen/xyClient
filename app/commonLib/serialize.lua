








function serialize(obj)
	local str_t = {};
	local t = type(obj);
	if t == "number" then
		str_t[#str_t + 1] = obj;
	elseif t == "boolean" then
		str_t[#str_t + 1] = tostring(obj);
	elseif t == "string" then
		str_t[#str_t + 1] = string.format("%q", obj);
	elseif t == "table" then
		str_t[#str_t + 1] = "{\n";
		for k, v in pairs(obj) do
			str_t[#str_t + 1] = "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n";
		end
		local metatable = getmetatable(obj);
		if metatable ~= nil and type(metatable.__index) == "table" then
			for k, v in pairs(metatable.__index) do
				str_t[#str_t + 1] = "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n";
			end
		end
		str_t[#str_t + 1] = "}";
	elseif t == "nil" then
		return nil;
	else
		error("can not serialize a " .. t .. " type.\n"..debug.traceback());
	end
	return table.concat(str_t, "\n");
end


function unserialize(str_code)
	local t = type(str_code)
	if t == "nil" or str_code == "" then
		return nil;
	elseif t == "number" or t == "string" or t == "boolean" then
		str_code = tostring(str_code);
	else
		error("can not unserialize a " .. t .. " type.\n"..debug.traceback());
	end
	str_code = "return " .. str_code;
	local func = loadstring(str_code);
	if func == nil then
		return nil
	end
	return func();
end


 