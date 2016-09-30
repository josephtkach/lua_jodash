-------------------------------------------------------------------------------
-- jodash
-- a lua implementation of lodash
-- by Joseph Tkach

-------------------------------------------------------------------------------
-- if you hide the global metatable with __metatable, you're going to have a 
-- bad time
local globalmt = getmetatable(_G)
setmetatable(_G, nil)
local saveOld__ = __

-------------------------------------------------------------------------------
__ = {}
local _jo = __

-------------------------------------------------------------------------------
local exports = {}
_jo._ = exports

-------------------------------------------------------------------------------
-- jodash, assemble!
_jo.array = require("jodash/array")
_jo.hash = require("jodash/hash")

-- these add to the global object
require("jodash/debug")
require("jodash/safe")
require("jodash/lang")
require("jodash/number")
require("jodash/object")
require("jodash/predicates")
require("jodash/private")
require("jodash/utils")

-------------------------------------------------------------------------------
-- compatibility
 __.unpack = unpack or table.unpack

-------------------------------------------------------------------------------
local ARRAY_TYPE = 1
local HASH_TYPE = 2
local OTHER_TYPE = 3

local retriever = {}
retriever[ARRAY_TYPE] = function(key, A) 
    return _jo.array[key] or rawget(_jo, key) or rawget(A, key)
end

retriever[HASH_TYPE] = function(key, A)
    return _jo.hash[key] or rawget(_jo, key) or rawget(A, key)
end

retriever[OTHER_TYPE] = function(key, A)
    return _jo.array[key] or _jo.hash[key] or rawget(_jo, key)
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
        -- don't allow access to internal data
        if not _jo.isFunction(func) then 
            assert(false, "Invalid key: " .. tostring(key))
            return nil
        end

        local count = select("#", ...)
        if count == 0 then
            out = func(A)
        else
            out = func(A, _jo.unpack({...}))
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
setmetatable(exports, {
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
__ = saveOld__
setmetatable(_G, globalmt)

-------------------------------------------------------------------------------
return exports
