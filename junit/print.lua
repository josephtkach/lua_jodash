
-------------------------------------------------------------------------------
-- debug printing
-------------------------------------------------------------------------------
local _print = print

-------------------------------------------------------------------------------
function success(msg)
    print(("SUCCESS: " .. msg).green)
end

-------------------------------------------------------------------------------
function warn(msg, showStack)
    print(("WARNING: " .. msg).yellowbg)

    if showStack then
        print(debug.traceback().yellow)
    end
end

-------------------------------------------------------------------------------
function assert_warn(boolean, msg)
    if not boolean then warn(msg) end
end

-------------------------------------------------------------------------------
function raiseError(msg, shortMessage)
    print(("ERROR: " .. msg).red)
    if shortMessage then
        _G[shortMessage] = function() crash() end
        _G[shortMessage]()
    end
end

-------------------------------------------------------------------------------
function vprint(object, msg)
    local indenting = string.rep("\t", (object.treeDepth or 0)+1)
    if object.verbose then print(indenting .. msg) end
end

-------------------------------------------------------------------------------
local defaultColor = "reset"
function vprint_default_color(color)
    defaultColor = color
end

-------------------------------------------------------------------------------
function vprintfield(object, msg, field)
    if not object then 
        print("vprintfield() was passed nil") 
        return
    end

    if not object.verbose then return end

    local indenting = string.rep("\t", (object.treeDepth or 0)+1)
    local color = "yellow"
    if field == nil then color = "red" end
    if type(field) == "table" then field = table_contents_to_oneliner(field) end

    print(indenting .. msg[defaultColor] .. " " .. tostring(field)[color]) 
end

-------------------------------------------------------------------------------
function vtprint(object)
    if not object then 
        print("vtprint() was passed nil") 
        return
    end

    if object.verbose then 
        local depth = (object.treeDepth or 0)+1
        tprint(object, depth, depth+5) 
    end
end

-------------------------------------------------------------------------------
function vtprint_nr(object, color)
    if object.verbose then 
        local depth = (object.treeDepth or 0)+1
        tprint_nr(object, depth, color)
    end
end


------------------------------------------------------------------------------
-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function tprint (tbl, indent, maxRecursions)
    if not tbl then print("table is nil"); return end
    -- detect empty table
    maxRecursions = maxRecursions or 5
    if indent and indent > maxRecursions then return end
    if not indent then indent = 0 end
   
    for k, v in pairs(tbl) do
        local formatting = string.rep("    ", indent) .. tostring(k).blue .. ": "
        -- this only fixes the bug when a table is its own __index, not for more complicated cycles
        if type(v) == "table" then
            print(formatting .."{")
            tprint(v, indent+1, maxRecursions)
            print(string.rep("  ", indent) .."}")
        else
          print(formatting .. tostring(v).yellow)      
        end
    end
end

-------------------------------------------------------------------------------
-- syntactic sugar for cross-compatibility with work
printTable = function(tbl, maxRecursions)
    tprint(tbl, 0, maxRecursions)
end

-------------------------------------------------------------------------------
function tprint_nr(table, indent, color)
    if getmetatable(table) and getmetatable(table).readonly then
        tprint_nr(getmetatable(table).original, indent, color)
        return
    end

    local printedSomething = false
    if not indent then indent = 1 end
    for k, v in pairs(table) do
        formatting = string.rep("  ", indent) .. tostring(k) .. ": "
        local output = formatting .. tostring(v)
        if color then output = output[color] end
        print(output)      
        printedSomething = true
    end

    if printedSomething == false then print(("table was empty").red) end
end

--------------------------------------------------------------------------------
function table_contents_to_oneliner(table)
    if not indent then indent = 1 end
    local output = "{ "
    for k, v in pairs(table) do
        output = output .. tostring(k) .."=" .. tostring(v) .. ", "
    end
    
    output = output .. "}"
    return output
end

--------------------------------------------------------------------------------
function to_s(...)
    local args = {...}
    local toPrint = ""

    for i,v in ipairs(args) do
        if type(v) == "table" then
            toPrint = toPrint .. " " .. table_contents_to_oneliner(v)
        elseif type(v) == "boolean" then
            toPrint = toPrint .. " BOOL:" .. tostring(v).yellow
        else
            toPrint = toPrint .. " " .. tostring(v)
        end
    end
    return toPrint
end

--------------------------------------------------------------------------------
function print(...)
    _print(to_s(...))
end
