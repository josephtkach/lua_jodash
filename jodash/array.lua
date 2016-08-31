-------------------------------------------------------------------------------
-- implementations for array tables
-------------------------------------------------------------------------------
local array = {}
local jo = __
local _insert = table.insert -- optimization

-------------------------------------------------------------------------------
-- mine
function array.append(A, x)
    if not A then A = {} end
    _insert(A, x)
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
            _insert(out, last)
            counter = 1
        end

        _insert(last, v)
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

    array.forEach({...}, function(arg)
        if jo.isTable(arg) then
            array.forEach(arg, _append)
        else
            _insert(out, arg)
        end
    end)

    return out
end

-------------------------------------------------------------------------------
-- core logic for difference
local function _difference(A, iteratee, args)
    local out = {}
    local test = {}

    local _assign = function(x)
        test[ iteratee(x) ] = true
    end

    array.forEach(args, function(arg)
        jo._.forEach(arg, _assign)
    end)

    array.forEach(A, function(x)
        if test[iteratee(x)] == nil then
            _insert(out, x)
        end 
    end)

    return out
end

-------------------------------------------------------------------------------
-- Creates an array of array values not included in the other given arrays 
-- The order of result values is determined by the order they occur in the 
-- first array. 
function array.difference(A, ...)
    return _difference(A, jo.identity, {...})
end

-------------------------------------------------------------------------------
function array.differenceBy(A, ...)
    local args = {...}
    local last = jo.private.pullLastIfNotTable(args)

    return _difference(A, jo.iteratee(last), args)
end

-------------------------------------------------------------------------------
local function _compareEachWith(lhs, rhsArray, comparator)
    for i,rhs in ipairs(rhsArray) do
        if comparator(lhs, rhs) then return true end
    end
    return false
end

-------------------------------------------------------------------------------
function array.differenceWith(A, ...)
    local out = {}
    local args = {...}
    local comparator = jo.private.pullLastIfFunction(args) 
    comparator = comparator or jo.sameValue

    array.forEach(A, function(lhs)
        for i,rhs in ipairs(args) do
            if _compareEachWith(lhs, rhs, comparator) then
                return 
            end
        end
        _insert(out, lhs)
    end)

    return out
end

-------------------------------------------------------------------------------
function array.drop(A, count)
    local out = {}
    for i = 1 + (count or 1), #A do
        _insert(out, A[i])
    end
    return out
end

-------------------------------------------------------------------------------
function array.dropRight(A, count)
    local out = {}
    count = #A - (count or 1)
    for i = 1, count do
        _insert(out, A[i])
    end
    return out
end

-------------------------------------------------------------------------------
function array.dropRightWhile(A, predicate)
    predicate = jo.iteratee(predicate)
    
    local out = {}
    -- the name "count" as opposed to "length" implies something
    -- pre- rather than descriptive, and as we are attempting to 
    -- prescribe a property of the right end of the array, (the 
    -- "length") count feels better than "length". See dropWhile
    count = 0

    local function backwards()
        for i = #A,1,-1 do
            count = i
            if jo.isFalsey(predicate(A[i], i, A)) then return end
        end
    end

    backwards()

    for i = 1, count do
        _insert(out, A[i])
    end

    return out
end

-------------------------------------------------------------------------------
function array.dropWhile(A, predicate)
    predicate = jo.iteratee(predicate)
    
    local out = {}
    local i = 1
    local length = #A
    -- length feels more descriptive than proscriptive, and as the length
    -- of the array is changing only artifactually as a result of changing
    -- the "start" of the array, we used it instead of "count"
    -- hence there is a jarring asymmetry between the nomenclature of
    -- dropWhile and dropRightWhile

    while i < length and not jo.isFalsey(predicate(A[i], i, A)) do
        i = i + 1
    end

    while i <= length do
        _insert(out, A[i])
        i = i + 1
    end

    return out
end

-------------------------------------------------------------------------------
-- Fills elements of array with value from start up to, but not including, end. 
-- Note: This mutates the array.
-------------------------------------------------------------------------------
-- This function deviates from lodash.fill
--  in javascript, 0-based arrays, iterated over [0, length)
--  in lua, 1-based arrays, iterated over [1, length]
-- I have preserved this convention.
-- MOREOVER. In javascript, an array can exist of #size and yet
-- be empty. In lua there is no such thing as an empty array slot,
-- so in order to simulate the idiom _.fill(Array(3), 2), we support
-- jo.fill(3, 2), which will cause this method to allocate a new array
function array.fill(A, value, startPos, endPos)
    local length
    if jo.isNumber(A) then
        length = A
        A = {}
    else
        length = #A
    end

    -- coerce bounds to integers
    endPos = math.floor(jo.clamp(endPos or length, length))
    startPos = math.floor(jo.clamp(startPos or 1, 1, length+1))

    for i = startPos, endPos do
        A[i] = value
    end
    return A
end

-------------------------------------------------------------------------------
-- This method is like _.find except that it returns the index of the first 
-- element predicate returns truthy for instead of the element itself.
function array.findIndex(A, predicate, fromIndex)
    predicate = jo.iteratee(predicate)
    local length = #A

    if jo.isFalsey(fromIndex) then fromIndex = 1 end
    if fromIndex > length then return -1 end
    fromIndex = math.floor(fromIndex) % (length+1)

    for i = fromIndex,length do
        if predicate(A[i]) then
            return i
        end
    end

    return -1
end

-------------------------------------------------------------------------------
--This method is like _.findIndex except that it iterates over elements of
-- the array from right to left.
function array.findLastIndex(A, predicate, fromIndex)
    predicate = jo.iteratee(predicate)
    local length = #A

    if jo.isFalsey(fromIndex) then fromIndex = length end
    if fromIndex < 0 then return -1 end
    fromIndex = math.floor(fromIndex) % (length+1)

    for i = fromIndex,1,-1 do
        if predicate(A[i]) then
            return i
        end
    end

    return -1
end

-------------------------------------------------------------------------------
-- helper for `flatten` functions
local function _flatten(A, output, depth, maxDepth)
    array.forEach(A, function(x)
        if depth < maxDepth and jo.isArray(x) then
            _flatten(x, output, depth+1, maxDepth)
        else
            _insert(output, x)
        end
    end)
end

-------------------------------------------------------------------------------
-- Flattens array a single level deep.
function array.flatten( A )
    local output = {}
    _flatten(A, output, 0, 1)
    return output
end

-------------------------------------------------------------------------------
-- Recursively flattens array.
function array.flattenDeep( A )
    local output = {}
    _flatten(A, output, 0, math.huge)
    return output
end

-------------------------------------------------------------------------------
-- Recursively flatten array up to depth times.
function array.flattenDepth( A, depth )
    local output = {}
    _flatten(A, output, 0, depth or 1)
    return output
end

-------------------------------------------------------------------------------
-- The inverse of _.toPairs; this method returns an object composed from key-value pairs.
function array.fromPairs(A)
    local output = {}
    array.forEach(A, function(x)
        for i = 1,2 do
            _insert(output, x[i])
        end
    end)
    return output
end

-------------------------------------------------------------------------------
-- Gets the first element of array.
function array.head(A)
    if not jo.isTable(A) then return nil end
    return A[1]
end

-------------------------------------------------------------------------------
array.first = array.head

-------------------------------------------------------------------------------
function array.filter( A, predicate )
    local output = {}
    array.forEach(A, function(x, k)
        if predicate(x, k, A) then _insert(output, x) end
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
    for i,v in ipairs(A) do
        predicate(v, i, A)
    end
    return A
end

-------------------------------------------------------------------------------
-- Gets the index at which the first occurrence of value is found in array
-- using == for comparisons. If fromIndex is negative, it’s used as the offset
-- from the end of array.
function array.indexOf(A, value, fromIndex)
    local pred = function(x) return value == x end
    return array.findIndex(A, pred, fromIndex)
end

-------------------------------------------------------------------------------
-- Gets all but the last element of array.
function array.initial(A)
   return array.dropRight(A, 1)
end

-------------------------------------------------------------------------------
-- core logic for intersection
local function _intersection(A, iteratee, args)
    local out = {}

    local sieves = array.map(args, function(x)
        return array.keyBy(x, iteratee)
    end)

    function inAll(x)
        for i,v in ipairs(sieves) do
            if not v[x] then return false end
        end
        return true
    end

    array.forEach(A, function(x)
        if inAll(iteratee(x)) then
            _insert(out, x)
        end 
    end)

    return out
end

-------------------------------------------------------------------------------
-- Creates an array of unique values that are included in all given arrays 
-- using luas innate hashing algorithm for comparisions. The order of result
-- values is determined by the order they occur in the first array.
function array.intersection(A, ...)
    return _intersection(A, jo.identity, {...})
end

-------------------------------------------------------------------------------
-- This method is like _.intersection except that it accepts iteratee which is 
-- invoked for each element of each arrays to generate the criterion by which 
-- they're compared. Result values are chosen from the first array. The
-- iteratee is invoked with one argument: (value).
function array.intersectionBy(A, ...)
    local args = {...}
    local last = jo.private.pullLastIfNotTable(args)
    return _intersection(A, jo.iteratee(last), args)
end

-------------------------------------------------------------------------------
-- This method is like _.intersection except that it accepts comparator which
-- is invoked to compare elements of arrays. Result values are chosen from the
-- first array. The comparator is invoked with two arguments: (arrVal, othVal)
function array.intersectionWith(A, ...)
    local out = {}
    local args = {...}
    local comparator = jo.private.pullLastIfFunction(args) 
    comparator = comparator or jo.sameValue

    array.forEach(A, function(lhs)
        for i,rhs in ipairs(args) do
            if not _compareEachWith(lhs, rhs, comparator) then
                return 
            end
        end
        _insert(out, lhs)
    end)

    return out
end


--------------------------------------------------------------------------------
-- helper for array.join
local function _coerceToString(A)
    if not jo.isTable(A) then return tostring(A) end

    local key, value
    local output = "{"

    local function iterate()
        key, value = next(A, key)
    end

    local function write(sep)
        output = output .. sep .. _coerceToString(key) .."=" .. _coerceToString(value)
    end

    iterate()
    if key then
        write("")
        iterate()

        while key do
            write(",")
            iterate()
        end
    end

    output = output .. "}"
    return output
end

-------------------------------------------------------------------------------
-- built in table.concat is much faster than this but it doesn't handle nested
-- tables, because lol. If you know there are no tables, you should use
-- table.concat
function array.join(A, separator)
    local length = #A
    if length == 0 then return "" end
    
    separator = separator or ','

    local out = _coerceToString(A[1])
    for i = 2,#A do
        out = out .. separator .. _coerceToString(A[i])
    end
    return out
end

-------------------------------------------------------------------------------
function array.keyBy( A, predicate )
    predicate = predicate or jo.identity
    local output = {}
    array.forEach(A, function(v, k)
        local newKey = predicate(v, k)
        output[newKey] = v
    end)
    return output
end

-------------------------------------------------------------------------------
function array.last(A)
    if not A then return nil end
    return A[#A]
end

-------------------------------------------------------------------------------
function array.lastIndexOf(A, value, fromIndex)
    -- todo: use a partial
    local pred = function(x) return value == x end 
    return array.findLastIndex(A, pred, fromIndex)
end

-------------------------------------------------------------------------------
function array.map( A, predicate )
    local output = {}
    for i,v in ipairs(A) do
        _insert(output, predicate(v, i))
    end
    return output
end

-------------------------------------------------------------------------------
function array.nth(A, index)
    if not A then return nil end

    local length = #A
    if index < 0 then index = index % (length + 1) end
    return A[index]
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
            _insert(removed, x)
        else
            _insert(intermediate, x)
        end
    end)

    local newCount = #intermediate
    for i = 1, newCount do
        _insert(A, intermediate[i])
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
        _insert(output, A[i])
    end

    return output
end

-------------------------------------------------------------------------------
-- mine
function array.splat(count, value)
    local A = {}
    for i = 1,count do
        _insert(A, value)
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
