-------------------------------------------------------------------------------
-- parse command line arguments for junit
-------------------------------------------------------------------------------
local commandLine = {}

-------------------------------------------------------------------------------
local lookup = {}

-------------------------------------------------------------------------------
local shorthands = {
    a = "all",
    c = "clear",
    h = "help",
    o = "only",
    s = "strict",
    v = "verbose",
}

-------------------------------------------------------------------------------
local function flag(name)
    lookup[name] = function(junit, subParams)
        junit[name] = true
    end
end

-------------------------------------------------------------------------------
local title = function(s) print(string.rep(" ", 4) .. green(s)) end
local body = function(s) print( string.wrap(s, 80, 8 ) .. '\n' ) end
-------------------------------------------------------------------------------
lookup.help = function(junit, subParams)
    junit.hr()
    
    title("all, a")
    body("The default behavior is to stop after the first error. Runs all tests regardless of failure")
    
    title("clear, c")
    body("Clear screen before running test")

    title("help, h")
    body("Show this message")

    title("only, o")
    body("run just the specified test. specified as `subsection.methodName.TestName`")

    title("strict, s")
    body("print a warning if no test is found for a method in a specified module")

    title("verbose, v")
    body("Show verbose output")
    print(" ")
end

-------------------------------------------------------------------------------
lookup.clear = function(junit, subParams)
    -- support other OS besides osx?
    pcall(function() 
        os.execute([[osascript -e 'if application "iTerm" is frontmost then tell application "System Events" to keystroke "k" using command down']])
    end)
end

-------------------------------------------------------------------------------
lookup.only = function(junit, subParams)
    junit.expandWhitelist(subParams:split(","))
end

-------------------------------------------------------------------------------
flag("all")
flag("strict")
flag("verbose")

-------------------------------------------------------------------------------
local function processArg(junit, v)
    local argName = v
    local subParams = nil

    local tokenized = v:split("=")
    local count = #tokenized

    if count > 2 then
        warn("malformed argument string: " .. v)
        return
    end

    if #tokenized > 1 then
        argName = tokenized[1]
        subParams = tokenized[2]
    end

    local processor = lookup[argName] or lookup[ shorthands[argName] ]
    if processor then
        processor(junit, subParams)
    end
end

-------------------------------------------------------------------------------
function commandLine.parse(junit, args)
    -- parse args. plenty of TODO here
        -- make args more n*x style
     -- better control for verbosity
    for i,v in pairs(args) do
        processArg(junit, v)
    end
end

-------------------------------------------------------------------------------
return commandLine
