-------------------------------------------------------------------------------
-- private.lua
-- internal functions for use by jodash
-------------------------------------------------------------------------------
local jo = __
local private = {}
jo.private = private

-------------------------------------------------------------------------------
private.defaultIteratee = jo.identity

-------------------------------------------------------------------------------
local function _resolveLast(args, default, resolver)
    local count = #args
    local last = args[count]

    if not jo.isTable(last) then
        args[count] = nil
        return resolver(last)
    end

    return default
end


-------------------------------------------------------------------------------
private.pullIteratee = function(args)
    return _resolveLast( args, private.defaultIteratee, function(last)
        return jo.isFunction(last) and last 
            or jo.property(last)
    end)
end

-------------------------------------------------------------------------------
private.pullComparator = function(args)
    return _resolveLast( args, jo.sameValue, jo.identity )
end

