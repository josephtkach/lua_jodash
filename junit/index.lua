-------------------------------------------------------------------------------
-- test harness code
-------------------------------------------------------------------------------
local exports = {}
exports.__index = exports

-------------------------------------------------------------------------------
-- compatibility
unpack = unpack or table.unpack

-------------------------------------------------------------------------------
require("junit/jstring")
require("junit/print")
require("junit/utils")
local commandLine = require("junit/commandLine")

exports.data = require("junit/data")

-------------------------------------------------------------------------------
local s = tostring
local report = {}
-- todo: better object-level management of state
local hardBail = false

-------------------------------------------------------------------------------
function exports.init(args)
    commandLine.parse(exports, args)
end

-------------------------------------------------------------------------------
function exports.expandWhitelist(tests)
    local whitelist = {}

    for _,test in pairs(tests) do
        local path = test:split(".")

        local iter = whitelist
        for i = 1,#path do
            local key = path[i]
            if not iter[key] then iter[key] = {} end
            iter = iter[key]
        end
    end

    exports.whitelist = whitelist
end

-------------------------------------------------------------------------------
function exports.testModule(args)
    local moduleName = args.name
    local obj = args.object

    local currentModule = exports.whitelist and exports.whitelist[moduleName]
    if exports.whitelist and not currentModule then return end

    local alphabetically = {}
    for k,v in pairs(obj) do
        table.insert(alphabetically, k)
    end

    table.sort(alphabetically, function(lhs, rhs) return lhs < rhs end)

    local function doTestMethod(methodName)
        local toTest = obj[methodName]
       
        if type(toTest) ~= "function" 
            or (exports.whitelist and not currentModule[methodName]) then 
            return 
        end

        local loaded = nil
        local found = pcall(function()
            loaded = require("tests/" .. methodName)
        end)

        exports.whitelistTests = currentModule and currentModule[methodName]
        if found then loaded:run() end
    end


    for index,methodName in ipairs(alphabetically) do
       doTestMethod(methodName)
    end

    exports.report()
    report = {}
    exports.whitelistTests = nil
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
local RESULT = 
{
    SKIPPED = 1,
    SUCCESS = 2,
    FAILURE = 3,
}

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

        local outcome = RESULT.SKIPPED

        local function try()
            local start = os.time()
            v.func(self.data, self.userData)
            elapsed = os.time() - start
        end

        local function catch(msg)
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

            outcome = RESULT.FAILURE
        end

        if exports.whitelistTests == nil
            or exports.whitelistTests[v.name] then
            if xpcall(try, catch) then outcome = RESULT.SUCCESS end
        end

        if outcome == RESULT.SUCCESS then
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
