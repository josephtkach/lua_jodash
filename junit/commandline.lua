-------------------------------------------------------------------------------
-- parse command line arguments for junit
-------------------------------------------------------------------------------
local commandLine = {}

-------------------------------------------------------------------------------
local lookup = {}

-------------------------------------------------------------------------------
local function flag(name)
    lookup[name] = function(junit, extra)
        junit[name] = true
    end
end

-------------------------------------------------------------------------------
local title = function(s) print(string.rep(" ", 4) .. green(s)) end
local body = function(s) print( string.wrap(s, 80, 8 ) ) end

-------------------------------------------------------------------------------
lookup.help = function(junit, extra)
    junit.hr()
    
    title("all")
    body("The default behavior is to stop after the first error. Runs all tests regardless of failure")
    
    title("clear")
    body("Clear screen before running test")
    
    title("help")
    body("Show this message")
    
    title("verbose")
    body("Show verbose output")
    print(" ")
end

-------------------------------------------------------------------------------
lookup.clear = function(junit, extra)
    -- support other OS besides osx?
    pcall(function() 
        os.execute([[osascript -e 'if application "iTerm" is frontmost then tell application "System Events" to keystroke "k" using command down']])
    end)
end

-------------------------------------------------------------------------------
flag("all")
flag("verbose")

-------------------------------------------------------------------------------
function commandLine.parse(junit, args)
    -- parse args. plenty of TODO here
        -- make args more n*x style
     -- better control for verbosity
    for i,v in pairs(args) do
        local processor = lookup[v]
        if processor then
            processor(junit, v)
        end
    end
end

-------------------------------------------------------------------------------
return commandLine
