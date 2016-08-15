-------------------------------------------------------------------------------
-- test harness code
-------------------------------------------------------------------------------
local exports = {}
exports.__index = exports

-------------------------------------------------------------------------------
require("junit/jstring")
require("junit/print")
require("junit/utils")

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
    print("\t\t" .. self.name.bright)
    exports:hr()

    local orderedTests = self.orderedTests

    for k,v in pairs(orderedTests) do
        local elapsed = 0
        local report = string.rep(" ", 8) .. v.name.blue .. ": "

        local succeeded = xpcall(function()
            local start = os.time()
            v.func(self.data, self.userData)
            elapsed = os.time() - start
        end, function(msg)
            report = report .. msg.red
            exports:hr()
            print(report)
            print(" at ")
            print(debug.traceback().red)
            exports:hr()
        end) 

        if succeeded then
            local toPad = 50 - report:len()
            report = report .. string.rep(" ", toPad) .. s("Succeeded").green
            --report = report .. " in " .. elapsed .. "ms"
            print(report)
        end
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
            table.insert(self.orderedTests, { name = key, func = value })
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
