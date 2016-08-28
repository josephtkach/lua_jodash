-------------------------------------------------------------------------------
-- private.lua
-- internal functions for use by jodash
-------------------------------------------------------------------------------
local jo = __
local private = {}
jo.private = private

-------------------------------------------------------------------------------
local function pullLastIf(args, predicate)
    local last = jo.last(args)
    
    if predicate(last) then
        args[#args] = nil
    else
        last = nil
    end

    return last
end

-------------------------------------------------------------------------------
-- helper for processing arguments when the last arg is an optional iteratee
function private.pullLastIfNotTable(args)
   return pullLastIf(args, function(x) return not jo.isTable(x) end)
end

-------------------------------------------------------------------------------
function private.pullLastIfFunction(args)
   return pullLastIf(args, jo.isFunction)
end

