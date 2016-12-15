------------------------------------------------------------------------------- 

-- syntactic sugar for tostring
s = tostring

-------------------------------------------------------------------------------
local colors = {1,2,3,4,5,6,7} -- mindless optimization
colors[0] = "red"
colors[1] = "green"
colors[2] = "yellow"
colors[3] = "blue"
colors[4] = "cyan"
colors[5] = "magenta"
colors[6] = "black"
colors[7] = "white"

local brights = { "identity", "bright", "dim" }

-------------------------------------------------------------------------------
local allIdentified = {}
local numIded = 0

-------------------------------------------------------------------------------
local function modulateColor(index, str)
    local fgbit = index % 8
    local bgbit = math.floor(math.max(index - 8, 0) / 7)
    local brightnessBit = 1 + math.floor(index / 56)

    if brightnessBit > 3 then
        warn("too many objects for colorFromIndex")
    end

    local fg = colors[fgbit]

    if bgbit == fgbit then bgbit = (bgbit + 1) % 7 end
    local bg = colors[bgbit]
    local bright = brights[brightnessBit]
    --print("str", fgbit, bgbit, brightnessBit)

    return str[fg][bg][bright]
end

-------------------------------------------------------------------------------
-- a function for making it easy to visually identify tables
idtbl = function(tbl)
    if not allIdentified[tbl] then
        allIdentified[tbl] = modulateColor(numIded, tostring(tbl)) 
        numIded = numIded + 1
    end

    return allIdentified[tbl]
end

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
