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
local report = {}

-------------------------------------------------------------------------------
function exports.init(args)
    -- parse args. plenty of TODO here
    for i,v in pairs(args) do
        if not exports[v] then exports[v] = true end
    end
end

-------------------------------------------------------------------------------
function exports.report()
    exports:hr()

    if report.succeeded > 0 then
        print("\t" .. tostring(report.succeeded .. " Succeeded!").green)
    end

    if report.failed > 0 then
        print("\t" .. tostring(report.failed .. " Failed!").red)
    end

    exports:hr()
    print(" ")
end

-------------------------------------------------------------------------------
function exports:hr()
    print(s("--------------------------------------------------------------------------------").white)
end

-------------------------------------------------------------------------------
function exports:printHeader()
    exports:hr()
    print("\t\t" .. self.name.bright)
    exports:hr()
end

-------------------------------------------------------------------------------
function exports:run()
    if exports.verbose then self:printHeader() end

    local orderedTests = self.orderedTests
    local succeededCount = 0
    local failedCount = 0

    local happenings = 0

    for k,v in pairs(orderedTests) do
        local elapsed = 0
        local results = string.rep(" ", 8) .. v.name.blue .. ": "

        local succeeded = xpcall(function()
            local start = os.time()
            v.func(self.data, self.userData)
            elapsed = os.time() - start
        end, function(msg)
            if not verbose then self:printHeader() end
            failedCount = failedCount + 1
            results = results .. msg.red
            exports:hr()
            print(results)
            print(" at ")
            print(debug.traceback().red)
            exports:hr()
        end) 

        if succeeded then
            succeededCount = succeededCount + 1
            if exports.verbose then
                local toPad = 50 - results:len()
                results = results .. string.rep(" ", toPad) .. s("Succeeded").green
                --results = results .. " in " .. elapsed .. "ms"
                print(results)
            end
        end
    end

    report.failed = (report.failed or 0) + failedCount
    report.succeeded = (report.succeeded or 0) + succeededCount
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
