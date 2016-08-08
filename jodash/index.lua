-------------------------------------------------------------------------------
-- functional.lua
-- a lua functional library by Joseph Tkach
-- those with strong opinions about the academic definition of "functional"
-- should probably avert their eyes; it is meant to be practical, not pedantic
-------------------------------------------------------------------------------
jo = {}
jo.__index = jo

-------------------------------------------------------------------------------
-- jodash, assemble!
local array = require("jodash/array")
local hash = require("jodash/hash")

-- these add to the global object
require("jodash/lang")
require("jodash/object")
require("jodash/utils")
require("jodash/debug")
require("jodash/safe")
require("jodash/predicates")

-------------------------------------------------------------------------------
local function getInvoker(key)
    return function(A, ...)
        local out

        -- get appropriate metatable for data structure
        local mt =  array
        if not jo.isArray(A) then
            mt = hash 
        end

        local func = mt[key] or rawget(A, key)
        local count = select("#", ...)
        if count == 0 then
            out = func(A)
        else
            out = func(A, unpack({...}))
        end
        -- hook if possible
        if getmetatable(out) == nil then
            setmetatable(out, jo)
        end

        return out
    end
end

-------------------------------------------------------------------------------
setmetatable(jo, {
    __index = function(self, key)
        return getInvoker(key)
    end
})

-------------------------------------------------------------------------------
function jo.new(A)
    local new
    if A then 
        new = deepCopy(A)
    else 
        new = {}
    end

    if getmetatable(new) ~= nil then
        print(" ")
        print("WARNING: Could not apply jodash metatable to object")
        print(debug.traceback())
    end
    setmetatable(new, jo)
    return new
end


--------------------------------------------------------------------------------
-- noop for compatibility with Message.Reader
jo.marshal = function(A) return A end

-------------------------------------------------------------------------------
return jo