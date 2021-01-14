local Formatter = {}
Formatter.default = {precision = 3, scale = "SI", unit = "" , delimiter = " ", removeTrailingZeros = true}
Formatter.scales = {
    SI = {"K", "M", "G", "T", "P", "E", "Z", "Y", [0] = "", [-1] = "m", [-2] = "μ", [-3] = "n", [-4] = "p", [-5] = "f", [-6] = "a", [-7] = "z", [-8] = "y"},
    shortScale = {"thousand", "million", "billion", "trillion", "quadrillion", "quintillion", "sextillion", "septillion", [0] = "", [-1] = "thousandth", [-2] = "millionth", [-3] = "billionth", [-4] = "trillionth", [-5] = "quadrillionth", [-6] = "quintillionth", [-7] = "sextillionth", [-8] = "septillionth"},
    longScale = {"thousand", "million", "milliard", "billion", "billiard", "trillion", "trilliard", "quadrillion", [0] = "", [-1] = "thousandth", [-2] = "millionth", [-3] = "milliardth", [-4] = "billionth", [-5] = "billiardth", [-6] = "trillionth", [-7] = "trilliardth", [-8] = "quadrillionth"}
}

local instance = {}
instance.__index = Formatter
local mt = {__index = instance}

local function isNumber(arg)
    return type(arg) == "number"
end

local function isInt(arg)
    return isNumber(arg) and arg == math.floor(arg)
end

local function isString(arg)
    return type(arg) == "string"
end

local function isStrings(...)
    for _, str in ipairs({...}) do
        if not isString(str) then
            return false
        end
    end
    return true
end

local function format(number, precision, removeTrailingZeros, delimiter, scale, unit) -- no type checking and defaulting
    assert(isNumber(number), "Wrong argument given for number, you can give only numbers!")

    local index = math.floor(math.log10(math.abs(number)) / 3)
    local prefix = Formatter.scales[scale][index] 
    local formattedNumber 

    if prefix then
        formattedNumber = string.format("%".. (removeTrailingZeros and "#" or "") .."." .. precision .. "f",  number / 10 ^ (index * 3))
        if removeTrailingZeros then
            formattedNumber = string.gsub(formattedNumber, "%.?0*$", "")
        end
    else -- defaults to standard behaviour, incase when number is bigger or smaller than 1e-+24 or is zero
        prefix = ""
        formattedNumber = string.format("%g", number)
    end

    return formattedNumber .. delimiter .. prefix .. unit
end

function instance:format(...)
    local returns = {}
    for _, number in ipairs({...}) do
       table.insert(returns, format(number, self.precision, self.removeTrailingZeros, self.delimiter, self.scale, self.unit) )
    end
    return unpack(returns)
end

function Formatter.new(precision, removeTrailingZeros, delimiter, scale, unit)
    -- set defaults
    precision = precision or Formatter.default.precision
    removeTrailingZeros = removeTrailingZeros == nil and Formatter.default.removeTrailingZeros or removeTrailingZeros
    delimiter = delimiter or Formatter.default.delimiter
    scale = scale or Formatter.default.scale
    unit = unit or Formatter.default.unit
    -- type checking
    assert(isInt(precision), "Wrong argument given for precision, you can give only integers!")
    assert(Formatter.scales[scale], "wrong argument given for scale, you can only give SI, shortScale or longScale!")
    assert(isStrings(delimiter, unit), "Wrong argument give for scale/unit, you can give only strings")

    return setmetatable({
        precision = precision,
        removeTrailingZeros = removeTrailingZeros,
        delimiter = delimiter,
        scale = scale,
        unit = unit
    }, mt)
end

function Formatter.format(number, ...)
    return Formatter.new(...):format(number)
end

return Formatter