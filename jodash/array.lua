-------------------------------------------------------------------------------
-- implementations for array tables
-------------------------------------------------------------------------------
local array = {}
local jo = __

-------------------------------------------------------------------------------
-- mine
function array.append(A, x)
    if not A then A = {} end
    table.insert(A, x)
    return A
end

-------------------------------------------------------------------------------
-- Creates an array of elements split into groups the length of size. 
-- If array can’t be split evenly, the final chunk will be the remaining elements.
function array.chunk(A, size)
    if not size or size < 1 then size = 1 end
    local out = {}
    local last = nil
    local counter = size+1

    array.forEach(A, function(v, k)
        if counter > size then
            last = {}
            table.insert(out, last)
            counter = 1
        end

        table.insert(last, v)
        counter = counter + 1
    end)

    return out
end

-------------------------------------------------------------------------------
-- Creates an array with all falsey values removed.
-- The values false, nil, 0, "", and NaN* are falsey. *not implemented yet
function array.compact(A)
    return array.filter(A, jo.isTruthy)
end

-------------------------------------------------------------------------------
-- Creates a new array concatenating array with any additional arrays and/or values. 
function array.concat(...)
    local out = {}
    local _append = function(x) table.insert(out, x) end

    local args = {...}

    if jo.isTable(args[1]) then 
        array.forEach(A, _append)
    end

    for i,v in ipairs({...}) do
        if type(v) == "table" then
            array.forEach(v, _append)
        else
            table.insert(out, v)
        end
    end
    return out
end

-------------------------------------------------------------------------------
function array.clone(A)
    local out = {}
    array.forEach(A, function(x)
        table.insert(out, x) 
    end)
    return out
end

-------------------------------------------------------------------------------
function array.difference(A, B)   -- the set of all B not in A
    local output = jo.new()
    -- note: replace this with a call to `keyBy`
    local A_has = array.keyBy(A, jo.identity)
    
    jo.forEach(B, function(x) 
        if A_has[x] == nil then
             append(output, x) 
        end 
    end)

    return output
end

-------------------------------------------------------------------------------
function array.filter( A, predicate )
    local output = {}
    array.forEach(A, function(x, k)
        if predicate(x, k, A) then table.insert(output, x) end
    end)
    return output
end

-------------------------------------------------------------------------------
function array.find(A, predicate)
    if not A then return nil end
    for k,v in pairs(A) do
        if predicate(v) then return v end
    end
end

-------------------------------------------------------------------------------
function array.forEach( A, predicate )
    if not A then return nil end
    for k,v in ipairs(A) do
        predicate(v, k, A)
    end
    return A
end

-------------------------------------------------------------------------------
function array.indexOf(A, value)
    if not A then return end
    for k,v in pairs(A) do
        if v == value then return k end
    end
    return nil
end

-------------------------------------------------------------------------------
function array.intersection(A, B)
    local output = {}
    local B_has = array.keyBy(B, jo.identity)
    
    array.forEach(A, function(x) 
        if B_has[x] then
             append(output, x) 
        end 
    end)

    return output
end

-------------------------------------------------------------------------------
function array.keyBy( A, predicate )
    local output = {}
    array.forEach(A, function(v, k)
        local newKey = predicate(v, k)
        output[newKey] = v
    end)
    return output
end

-------------------------------------------------------------------------------
function jo.last(A)
    -- assumes a continuous array
    if not A then return nil end
    return A[#A]
end

-------------------------------------------------------------------------------
function array.map( A, predicate )
    local output = {}
    for i,v in ipairs(A) do
        table.insert(output, predicate(v, i))
    end
    return output
end

-------------------------------------------------------------------------------
local function modularCount(A, count)
    local length = array.size(A)

    if count < 0 then
        count = count % #A
    end

    if count == 0 then 
        count = #A
    end

    return count
end

-------------------------------------------------------------------------------
function array.nth(A, index, action)
    if not A then return nil end
    local index = modularCount(A, index)

    local count = 1
    for k,v in pairs(A) do
        if count == index then
            if action then return action(v) end
            return v
        end 
        count = count + 1
    end

    return nil
end

-------------------------------------------------------------------------------
function array.reduce(A, accumulator, predicate)
    for k,v in pairs(A) do
        accumulator = predicate(v, accumulator)
    end

    return accumulator
end

-------------------------------------------------------------------------------
function array.remove(A, predicate)
    local removed = {}
    local intermediate = {}

    array.forEach(A, function(x, k)
        A[k] = nil
        if predicate(x, k) then 
            table.insert(removed, x)
        else
            table.insert(intermediate, x)
        end
    end)

    local newCount = #intermediate
    for i = 1, newCount do
        table.insert(A, intermediate[i])
    end

    return removed
end

-------------------------------------------------------------------------------
function array.sample(A)
    return array.sampleSlice(A, 1, #A)
end

-------------------------------------------------------------------------------
-- mine
function array.sampleSlice(A, min, max)
    if not A then return nil end

    local index = min
    if min < max then
        index = math.random(min, max)
    end

    return A[index] or print("WARNING: invalid range supplied to sampleSlice")
end

-------------------------------------------------------------------------------
function array.size(A)
    return #A
end

-------------------------------------------------------------------------------
function array.slice(A, count)
    if not A then return A end
    local output = {}

    count = modularCount(A,count)
    
    for i = 1, count do
        if not A[i] then return output end
        table.insert(output, A[i])
    end

    return output
end

-------------------------------------------------------------------------------
-- mine
function array.splat(count, value)
    local A = {}
    for i = 1,count do
        table.insert(A, value)
    end
    return A
end

-------------------------------------------------------------------------------
function array.union(A, B)
    local output = {}

    jo.concat(output, A)
    jo.concat(output, B)
    return output
end

-------------------------------------------------------------------------------
function array.uniq( A )
    local A_has = array.keyBy(A, jo.identity)
    return array.keys(A_has)
end

-------------------------------------------------------------------------------
return array
