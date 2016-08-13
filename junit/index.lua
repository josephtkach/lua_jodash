-------------------------------------------------------------------------------
-- test harness code
-------------------------------------------------------------------------------
local exports = {}
exports.__index = exports

-------------------------------------------------------------------------------
require("junit/utils")
require("junit/jstring")
require("junit/print")

exports.data = require("junit/data")

-------------------------------------------------------------------------------
local s = tostring

-------------------------------------------------------------------------------
function exports:hr()
    print(s("--------------------------------------------------------------------------------").white)
end

-------------------------------------------------------------------------------
function exports:run()
    exports:hr()
    print("Running test: " .. self.name.bright)
    exports:hr()

    local orderedTests = self.orderedTests
    local lastWasFailure = false

    for k,v in pairs(orderedTests) do
        local report = string.rep(" ", 8) .. v.name.blue .. ": "

        local succeeded = xpcall(function()
            v.func(self.data, self.userData)
        end, function(msg)
            report = report .. msg.red
            exports:hr()
            print(report)
            print(" at ")
            print(debug.traceback().red)
            lastWasFailure = true
            exports:hr()
        end) 

        if succeeded then
            local toPad = 50 - report:len()
            report = report .. string.rep(" ", toPad) .. s("Succeeded").green
            print(report)
            lastWasFailure = false
        end
    end
    
    if not lastWasFailure then exports:hr() end
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
