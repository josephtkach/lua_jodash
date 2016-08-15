local red     = function(str) return tostring(str).red end
local green   = function(str) return tostring(str).green end
local yellow  = function(str) return tostring(str).yellow end
local blue    = function(str) return tostring(str).blue end
local magenta = function(str) return tostring(str).magenta end
local cyan    = function(str) return tostring(str).cyan end
local white   = function(str) return tostring(str).white end

-------------------------------------------------------------------------------
local print = function() end

-------------------------------------------------------------------------------
-- from http://lua-users.org/wiki/CopyTable
function deepCopy(orig, seen, depth)
    depth = depth or -1
    depth = depth + 1

    local indent = string.rep("  ", depth)
    local isTable = type(orig) == "table"
    local copy

    print(indent .. "copying " .. white(orig))

    local seen = seen or {}
    --for k,v in pairs(seen) do 
    --    print(indent .. "    " .. white(k) .. " : " .. white(v))
    --end
    local s = seen

    if orig == nil then return nil end
    if seen[orig] then 
        print(white(indent .. "returning cached value ") .. blue(orig))
        return seen[orig] 
    end

    if isTable then
        copy = {}

        print(indent .. "memoized copy")
        seen[orig] = copy

        for orig_key, orig_value in next, orig, nil do
            print(indent .. "copying key " .. magenta(orig_key))
            copy[deepCopy(orig_key, seen, depth)] = deepCopy(orig_value, seen, depth)
        end

        print(red(indent .. "copying metatable"))
        setmetatable(copy, deepCopy(getmetatable(orig), seen, depth))
    else -- number, string, boolean, etc
        print(green(indent .. "literal copy ") .. white(orig))
        copy = orig
    end

    return copy
end
