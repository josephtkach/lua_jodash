-------------------------------------------------------------------------------
local jo = __

-------------------------------------------------------------------------------
local _functor = function(data, call)
    local out = data or {}

    setmetatable(out, {
        __call = call
    })
    return out
end

-------------------------------------------------------------------------------
jo.functor = _functor

-------------------------------------------------------------------------------
local function _isArray(A)
    if #A == 0 then
        for k,v in pairs(A) do
            return false
        end
    end
    return true
end

-------------------------------------------------------------------------------
jo.isArray = _functor({ dangerous = _isArray },
    function(self, A)
        if A == nil or type(A) ~= "table" then return false end
        return self.dangerous(A)
    end
)

-------------------------------------------------------------------------------
function jo.isEmpty(A)
    return not A or next(A) == nil
end

-------------------------------------------------------------------------------
local function _deepCompare(lhs, rhs, comparator, equiv)
    -- todo: should compare metatables?
    -- todo: handle cyclic graphs
    comparator = comparator or jo.sameValue
    local isTable = jo.isTable(lhs)
    if isTable then
        if not jo.isTable(rhs) then 
            return false 
        end

        for k,v in pairs(lhs) do
            if not equiv(v, rhs[k], comparator) then
                return false 
            end
        end
    else
        local eq = comparator(lhs, rhs)
        return eq
    end

    return true, isTable
end

-------------------------------------------------------------------------------
function jo.isEqual(lhs, rhs, comparator)
    local match, isTable = _deepCompare(lhs, rhs, comparator, jo.isEqual)
    if not match then
        return false
    end

    if isTable then
        for k,v in pairs(rhs) do
            if jo.isNil(lhs[k]) then return false end
        end
    end

    return true
end

-------------------------------------------------------------------------------
function jo.isFalsey(A)
    return A == nil
        or A == false
        or A == ""
        or A == 0
        --or isNan(A) -- todo: bind a C++ NaN check
end

-------------------------------------------------------------------------------
function jo.isFunction(A)
    return type(A) == "function"
end

-------------------------------------------------------------------------------
function jo.isMatch(lhs, rhs, comparator)
    return _deepCompare(lhs, rhs, comparator, jo.isMatch)
end

-------------------------------------------------------------------------------
function jo.isNil(A)
    return A == nil
end

-------------------------------------------------------------------------------
function jo.isNotNil(A)
    return A ~= nil
end

-------------------------------------------------------------------------------
function jo.isNumber(A)
    return type(A) == "number"
end

-------------------------------------------------------------------------------
function jo.isTable(A)
    return type(A) == "table"
end

-------------------------------------------------------------------------------
function jo.isTruthy(A)
    return not jo.isFalsey(A)
end

-------------------------------------------------------------------------------
function jo.sameValue(lhs, rhs)
    return lhs == rhs
end

-------------------------------------------------------------------------------
-- compatibility
local gfind = string.gfind
local strfind = string.find
local strsub = string.find
if _VERSION == "Lua 5.2" then gfind = string.gmatch end

-------------------------------------------------------------------------------
function jo.strSplit(str, delim, maxNb)
    if delim == '.' then delim = '%.' end
    -- Eliminate bad cases...
    if strfind(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = strsub(str, lastPos)
    end
    return result
end

-------------------------------------------------------------------------------
function jo.strLastIndexOf(haystack, needle)
    local i = haystack:match(".*"..needle.."()")
    if i == nil then return nil else return i-1 end
end

-------------------------------------------------------------------------------
function jo.swap(A,B)
    return B, A
end

-------------------------------------------------------------------------------
local _insert = table.insert -- optimization
function jo.toArray(A)
    local output = set.new()
    for k,v in pairs(A) do
        _insert(output, v)
    end
    return output
end
