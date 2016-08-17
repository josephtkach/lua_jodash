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
            -- caveat invoker
            return jo.matchesProperty(x[1], x[2])
        else -- is hash
            return jo.matches(x)
        end
    end

    return jo.property(x)
end

-------------------------------------------------------------------------------
function jo.matchesProperty(path, sourceValue)
    -- todo: implement this in terms of `partial`
    return function(A)
        return jo.isEqual(jo.get(A, path), sourceValue)
    end
end

-------------------------------------------------------------------------------
function jo.matches(x)
    -- todo: implement this in terms of `partial`
    return function(A)
        return jo.isMatch(A, x)
    end
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
