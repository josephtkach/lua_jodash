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
-- todo: better object-level management of state
local hardBail = false

-------------------------------------------------------------------------------
function exports.init(args)
    -- parse args. plenty of TODO here
    -- like move this to its own file
    -- make args more n*x style
    -- use a lookup table
    -- better control for verbosity
    for i,v in pairs(args) do
        if v == "clear" then
            pcall(function() 
                os.execute([[osascript -e 'if application "iTerm" is frontmost then tell application "System Events" to keystroke "k" using command down']])
            end)
        else
            if not exports[v] then exports[v] = true end
        end
    end
end

-------------------------------------------------------------------------------
function exports.runTestsForObject(object)
    local alphabetically = {}
    for k,v in pairs(object) do
        table.insert(alphabetically, k)
    end

    table.sort(alphabetically, function(lhs, rhs) return lhs < rhs end)

    for index,name in ipairs(alphabetically) do
        local toTest = object[name]
        if type(toTest) == "function" then
            local loaded = nil
            local found = pcall(function()
                loaded = require("tests/" .. name)
            end)
            if found then loaded:run() end
        end
    end

    exports.report()
    report = {}
end

-------------------------------------------------------------------------------
function exports.report()
    if hardBail then return end
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

    for k,v in pairs(orderedTests) do
        if hardBail then 
            return
        end

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

            if not exports.all then
                hardBail = true
                print("Stopping after first failure")
            end
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
function exports:omit(tests)
    for k,v in pairs(tests) do
        self[v] = nil
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
