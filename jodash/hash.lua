-------------------------------------------------------------------------------
-- implementations for hashtable tables
-------------------------------------------------------------------------------
local hash = {}
local jo = __

-------------------------------------------------------------------------------
function hash.differenceKeys(A, B)    -- the set of all B not in A
    local output = {}

    hash.forEach(B, function(x, k)
        if A[k] == nil then
            output[k] = x
        end
    end)

    return output
end

-------------------------------------------------------------------------------
function hash.forEach( A, predicate )
    if not A then return nil end
    for k,v in pairs(A) do
        predicate(v, k, A)
    end
    return A
end

-------------------------------------------------------------------------------
function hash.merge(A, B)
    local output = {}
    --set.concatenateKVP(output, A)
    --set.concatenateKVP(output, B)
    return output
end

-------------------------------------------------------------------------------
local function hashSize(A)
    local count = 0
    if A then
        for k,v in pairs(A) do count = count + 1 end
    end
    return count
end

-------------------------------------------------------------------------------
function hash.remove(A, predicate)
    local removed = {}

    hash.forEach(A, function(x, k)
        if not predicate(x, k) then 
            A[k] = nil
            removed[k] = x
        end
    end)
    return removed
end

-------------------------------------------------------------------------------
function hash.size(A)
    return hashSize(A) 
end

-------------------------------------------------------------------------------
function hash.map( A, predicate )
    local output = {}

    for k,v in pairs(A) do
        output[k] = predicate(v, k)
    end

    return output
end

-------------------------------------------------------------------------------
return hash
