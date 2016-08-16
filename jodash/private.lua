-------------------------------------------------------------------------------
-- private.lua
-- internal functions for use by jodash
-------------------------------------------------------------------------------
local jo = __
local private = {}
jo.private = private

-------------------------------------------------------------------------------
private.pullComparator = function(default, args)
    local count = #args
    local last = args[count]

    if jo.isFunction(last) then
        args[count] = nil
        return last 
    end

    return default
end

