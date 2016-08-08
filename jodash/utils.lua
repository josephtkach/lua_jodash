-------------------------------------------------------------------------------
-- functions that are data-structure-agnostic
-------------------------------------------------------------------------------
function jo.identity(x)
    return x
end

-------------------------------------------------------------------------------
-- mine
function jo.plainOldData(A)
    setmetatable(A, nil)
    return A
end

