-------------------------------------------------------------------------------
-- test harness code
-------------------------------------------------------------------------------
local exports = {}
exports.__index = exports

-------------------------------------------------------------------------------
require("junit/utils")
require("junit/jstring")
require("junit/print")

-------------------------------------------------------------------------------
local s = tostring

-------------------------------------------------------------------------------
local function hr()
    print(s("--------------------------------------------------------------------------------").white)
end

-------------------------------------------------------------------------------
exports.data = {}
-- todo: make a factory for objects of this type
setmetatable(exports.data, { __index = function(self, key)
    return deepCopy(rawget(self, key))
end })

-------------------------------------------------------------------------------
exports.data.empty = {}

-------------------------------------------------------------------------------
exports.data.alphabet = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' }

-------------------------------------------------------------------------------
exports.data.ten = {}
for i = 1,10 do
    exports.data.ten[i] = i
end

-------------------------------------------------------------------------------
function exports:run()
    hr()
    print("Running test: " .. self.name)
    hr()

    local orderedTests = self.orderedTests

    for k,v in pairs(orderedTests) do
        local report = v.name.blue .. ": "

        local succeeded = xpcall(function()
            v.func(self.data)
        end, function(msg)
            report = report .. msg.red
            print(report)
            print(" at ")
            print(debug.traceback().red)
        end) 

        if succeeded then
            local toPad = 80 - report:len()
            report = report .. string.rep(" ", toPad) .. s("Succeeded").green
            print(report)
        end
        hr()
    end
end

-------------------------------------------------------------------------------
function exports:new(params)
    local outmt = deepCopy(params)
    outmt.__index = outmt
    setmetatable(outmt, exports)

    outmt.orderedTests = {}

    outmt.__newindex = function(self, key, value)
        if type(value) == "function" then
            table.insert(outmt.orderedTests, { name = key, func = value })
        else
            rawset(self, key, value)
        end
    end

    local out = {}
    setmetatable(out, outmt)
    return out
end


-------------------------------------------------------------------------------
return exports
