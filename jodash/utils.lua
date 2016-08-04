-------------------------------------------------------------------------------
-- functions that are data-structure-agnostic
-------------------------------------------------------------------------------
local jo = {}

-------------------------------------------------------------------------------
function jo.identity(x)
    return x
end

-------------------------------------------------------------------------------
function set.plainOldData(A)
    setmetatable(A, nil)
    return A
end

-------------------------------------------------------------------------------
function set.print(A, label)
    if not A then return end
    if label then print(label) end
    printTable(A, 99)
    return A
end



-------------------------------------------------------------------------------
return jo
