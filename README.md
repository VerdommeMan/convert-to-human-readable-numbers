# Convert to numbers into a human readable format
A roblox lua module that converts numbers into a human readable format. It offers a wide customization.

## TOC
- [Customization](#Customization)
- [Code examples](#Code-examples)
- [API](#API)
- [Notes](#Notes)

## Customization
### Specify the numbers behind the decimal point
This module allows you the specify the precision, when given a precision of zero, it will remove the decimal point.

### Option to remove trailing zeros
This module has a option to remove trailing zeros when you set a precision.

### Option to specify the space between the formatted number and prefix
This module allows you to set a delimiter between the number and the prefix

### scales
This module has by default three scales, SI-prefixes, short scale and long scale. It also allows you to add your own scales. This will be refered to as the prefix.

## Option to specify the unit
It allows you set a unit/suffix

In the end your formatted string will look like this
`number``.precision``delimiter``prefix``unit`


## Code examples

```lua
local ServerStorage = game:GetService('ServerStorage')
local Benchmarker = require(ServerStorage:WaitForChild("ReadableNumbers"))

print(Formatter.format(1e9)) --1 G
print(Formatter.format(1e9, 2, false, " ", "longScale", " s")) --1.00 milliard s
local formatter = Formatter.new()
print(formatter:format(10, 15, 1e9, 1e-9, 10.4554777, math.pi, 4.14001e-08, 2.32821e+07, -10, -1e9 , -math.pi, 0, 10.12)) --10  15  1 G 1 n 10.455  3.142  41.4 n 23.282 M -10  -1 G -3.142  0  10.12 
local formatter2 = Formatter.new(3, nil, "", "SI", "B")
print(formatter2:format(10, 15, 1e9, 1e-9, 10.4554777, math.pi, 4.14001e-08, 2.32821e+07, -10, -1e9 , -math.pi, 0, 10.12)) --10B 15B 1GB 1nB 10.455B 3.142B 41.4nB 23.282MB -10B -1GB -3.142B 0B 10.12B
```


## API
Is in form: `returnType function(argumentName:type, argumentName:type defaultValue)`

### Constructors

`formatter` Formatter.new(specifier:`int` 3, removeTrailingZeros:`boolean` true, delimiter:`string` " ", scale:`string` "SI", unit:`string` "")
It returns a Formatter instance, all properties can be changed by indexing the argument name. There are three scales by default: "SI", "shortScale", "longScale".

### Methods
`...:string` formatter:format(...:`number`)
It returns the formatted numbers using the properties from the formatter instance, note that this is a variadic function.

### Static properties

#### scales:`Dictionary`
##### Scales contains the scales used for the prefix. By default there are three scales: SI-prefixes, short scale, long scale.
##### It has as key the scale type ("SI") and as value a mixed table, where the key is the power by three, eig : 1 -> "K"(1e3) 2-> "M"(1e6) and value is the prefix. 
##### It goes negative for prefixes below zero.

#### default:`Dictionary`
##### This dictionary contains the default values used, modifying this allows different default values to be set.

### Functions

#### string Formatter.format(number:number, removeTrailingZeros:boolean true, delimiter:string " ", scale:string "SI", unit:string "")
##### It returns the formatted numbers using the given properties.

####
## Notes
- Numbers bigger or smaller than 1e±24 and zero will not be formatted but will have delimiter and prefix and unit added. This can be overcome by expanding the scales.
- It does only type checks the arguments, so you can set wrong type of the properties