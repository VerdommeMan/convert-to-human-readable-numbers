local prefixes = {"K", "M", "G", "T", "P", "E", "Z", "Y", [0] = "", [-1] = "m", [-2] = "μ", [-3] = "n", [-4] = "p", [-5] = "f", [-6] = "a", [-7] = "z", [-8] = "y"}

local function isNumber(arg)
    return type(arg) == "number"
end

local function toReadable(self, ...)
    local returns = {}
    for _, number in ipairs({...}) do
        if isNumber(number) then
            local index = math.floor(math.log10(number) / 3)    
            if index > -9 and index < 9 then
                table.insert(returns, (string.gsub(string.format("%#." .. self.precision .. "f",  number / 10 ^ (index * 3)), "%.0*$", "")) .. prefixes[index])
            else
                table.insert(returns, string.format("%g", number))
            end
        else
            error("Wrong arguments given, you can give only numbers!")
        end
    end
    return unpack(returns)
end

return setmetatable({precision = 3}, {__call = toReadable})