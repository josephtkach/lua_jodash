-------------------------------------------------------------------------------
function jo.isArray(A)
    if A == nil then return false end
    if #A == 0 then
        for k,v in pairs(A) do
            return false
        end
    end

    return true
end

-------------------------------------------------------------------------------
function jo.isEmpty(A)
    return not A or next(A) == nil
end

-------------------------------------------------------------------------------
function jo.isFalsey(A)
    return A == nil
        or A == false
        or A == ""
        or A == 0
        --or isNan(A) -- todo: bind a C++ NaN check
end

-------------------------------------------------------------------------------
function jo.isTruthy(A)
    return not jo.isFalsey(A)
end

-------------------------------------------------------------------------------
function jo.toArray(A)
    local output = set.new()
    for k,v in pairs(A) do
        table.insert(output, v)
    end
    return output
end
