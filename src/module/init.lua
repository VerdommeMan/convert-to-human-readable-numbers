local scales = {
    SI = {"K", "M", "G", "T", "P", "E", "Z", "Y", [0] = "", [-1] = "m", [-2] = "μ", [-3] = "n", [-4] = "p", [-5] = "f", [-6] = "a", [-7] = "z", [-8] = "y"},
    shortScale = {"thousand", "million", "billion", "trillion", "quadrillion", "quintillion", "sextillion", "septillion", [0] = "", [-1] = "thousandth", [-2] = "millionth", [-3] = "billionth", [-4] = "trillionth", [-5] = "quadrillionth", [-6] = "quintillionth", [-7] = "sextillionth", [-8] = "septillionth"},
    longScale = {"thousand", "million", "milliard", "billion", "billiard", "trillion", "trilliard", "quadrillion", [0] = "", [-1] = "thousandth", [-2] = "millionth", [-3] = "milliardth", [-4] = "billionth", [-5] = "billiardth", [-6] = "trillionth", [-7] = "trilliardth", [-8] = "quadrillionth"}
}

local function isNumber(arg)
    return type(arg) == "number"
end

local function toReadable(self, ...)
    local returns = {}
    for _, number in ipairs({...}) do
        if isNumber(number) then
            local index = math.floor(math.log10(math.abs(number)) / 3)
            local prefix = scales[self.scale][index] or ""
            local formattedNumber   
            if index > -9 and index < 9 then
                formattedNumber = string.format("%".. (self.removeTrailingZeros and "#" or "") .."." .. self.precision .. "f",  number / 10 ^ (index * 3))
                if self.removeTrailingZeros then
                    formattedNumber = string.gsub(formattedNumber, "%.?0*$", "")
                end
            else
                formattedNumber = string.format("%g", number)
            end
            table.insert(returns, formattedNumber .. self.delimiter .. prefix .. self.unit)
        else
            error("Wrong arguments given, you can give only numbers!")
        end
    end
    return unpack(returns)
end

return setmetatable({precision = 3, scale = "SI", unit = "s" , delimiter = " ", removeTrailingZeros = true}, {__call = toReadable})