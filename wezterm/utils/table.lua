local function merge(...)
	local merged = {}

	-- 如果键相同，后面的会覆盖前面的
	for _, t in ipairs({ ... }) do
		if type(t) == "table" then
			for key, value in pairs(t) do
				merged[key] = value
			end
		end
	end

	return merged
end

return {
	merge = merge,
}
