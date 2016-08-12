-------------------------------------------------------------------------------
-- jodash
-- a lua implementation of lodash
-- by Joseph Tkach
-------------------------------------------------------------------------------
assert(__ == nil, 
    "jodash requires __ to be an available key in _G in order to initialize")

-------------------------------------------------------------------------------
__ = {}
local _jo = __

-------------------------------------------------------------------------------
local jo = {}

-------------------------------------------------------------------------------
-- jodash, assemble!
_jo.array = require("jodash/array")
_jo.hash = require("jodash/hash")

-- these add to the global object
require("jodash/lang")
require("jodash/object")
require("jodash/utils")
require("jodash/debug")
require("jodash/safe")
require("jodash/predicates")

-------------------------------------------------------------------------------
local ARRAY_TYPE = 1
local HASH_TYPE = 2
local OTHER_TYPE = 3

local retriever = {}
retriever[ARRAY_TYPE] = function(key, A) 
    return _jo.array[key] or rawget(jo, key) or rawget(A, key)
end

retriever[HASH_TYPE] = function(key, A)
    return _jo.hash[key] or rawget(jo, key) or rawget(A, key)
end

retriever[OTHER_TYPE] = function(key, A)
    return _jo.array[key] or _jo.hash[key] or rawget(jo, key)
end

-------------------------------------------------------------------------------
local function getInvoker(key)
    return function(A, ...)
        local out

        -- get appropriate metatable for data structure
        local objectType = HASH_TYPE
        if _jo.isTable(A) and _jo.isArray.dangerous(A) then
            objectType = ARRAY_TYPE
        else 
            objectType = OTHER_TYPE 
        end
        
        local func = retriever[objectType](key, A)
        local count = select("#", ...)
        if count == 0 then
            out = func(A)
        else
            out = func(A, unpack({...}))
        end
        -- hook if possible
        if _jo.isTable(out) and getmetatable(out) == nil then
            setmetatable(out, wrapped)
        end

        return out
    end
end

-------------------------------------------------------------------------------
function _jo.new(A)
    local new
    if A then 
        new = deepCopy(A) -- todo
    else 
        new = {}
    end

    if getmetatable(new) ~= nil then
        print(" ")
        print("WARNING: Could not apply jodash metatable to object")
        print(debug.traceback())
    end
    setmetatable(new, _jo)
    return new
end

-------------------------------------------------------------------------------
setmetatable(jo, {
    __index = function(self, key)
        return getInvoker(key)
    end,
    __call = function(self, A)
        return _jo.new(A)
    end
})

--------------------------------------------------------------------------------
-- noop for compatibility with Message.Reader
_jo.marshal = function(A) return A end

--------------------------------------------------------------------------------
-- scrub the global table
__ = nil

-------------------------------------------------------------------------------
return jo