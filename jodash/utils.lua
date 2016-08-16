-------------------------------------------------------------------------------
-- functions that are data-structure-agnostic
-------------------------------------------------------------------------------
local jo = __

-------------------------------------------------------------------------------
function jo.identity(x)
    return x
end

-------------------------------------------------------------------------------
function jo.iteratee(x)
    if x == nil then return jo.identity end
    
    if jo.isFunction(x) then return x end

    if jo.isTable(x) then
        if jo.isArray.dangerous(x) then
            return jo.matchesProperty(x)
        else -- is hash
            return jo.matches(x)
        end
    end

    return jo.property(x)
end

-------------------------------------------------------------------------------
-- mine
function jo.plainOldData(A)
    setmetatable(A, nil)
    return A
end

-------------------------------------------------------------------------------
function jo.property(x)
    return function(A)
        return jo.get(A, x)
    end
end

-------------------------------------------------------------------------------
