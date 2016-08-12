-------------------------------------------------------------------------------
-- implementations for hashtable tables
-------------------------------------------------------------------------------
local hash = {}
local jo = __

-------------------------------------------------------------------------------
local function assign_inner(A, B, allowOverwrite)
    if not A then A = {} end
    if not B then return A end
    
    hash.forEach(B, function(v, k)
        local rhs = A[k]
        if rhs then
            if isTable(rhs) then
                A[k] = assign_inner(v, rhs, allowOverwrite)
            elseif allowOverwrite then
                A[k] = v 
            end
        else
            A[k] = v 
        end
    end)

    return A
end

-------------------------------------------------------------------------------
function hash.assign(A, B, allowOverwrite)
    return assign_inner(A, B, allowOverwrite)
end

-------------------------------------------------------------------------------
function hash.clone(A)
    return assign_inner(nil, A)
end

-------------------------------------------------------------------------------
function hash.differenceKeys(A, B)    -- the set of all B not in A
    local output = {}

    hash.forEach(B, function(v, k)
        if A[k] == nil then
            output[k] = v
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
