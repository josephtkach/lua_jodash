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
    return A, x
end

-------------------------------------------------------------------------------
-- mine
function array.pop(A)
    if not A then return nil end
    local count = #A
    local toReturn = A[count]
    A[count] = nil
    return toReturn
end

-------------------------------------------------------------------------------
-- Creates an array of elements split into groups the length of size. 
-- If array can’t be split evenly, the final chunk will be the remaining elements.
function array.chunk(A, size)
    if not size or size < 1 then size = 1 end
    local out = {}
    local last = nil
    local counter = size+1

    array.forEach(A, function(x, k)
        if counter > size then
            last = {}
            _insert(out, last)
            counter = 1
        end

        _insert(last, x)
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
    local _append = function(x) _insert(out, x) end

    for i,arg in ipairs({...}) do
        if jo.isTable(arg) then
            array.forEach(arg, _append)
        else
            _insert(out, arg)
        end
    end

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

    for i,arg in ipairs(args) do
        array.forEach(arg, _assign)
    end

    for i,v in ipairs(A) do
        if test[iteratee(v)] == nil then
            _insert(out, v)
        end 
    end

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
    return array.slice(A, 1 + (count or 1))
end

-------------------------------------------------------------------------------
function array.dropRight(A, count)
    local length = #A
    local endIndex = jo.clamp(length - (count or 1), 0, length)
    return array.slice(A, 1, endIndex)
end

-------------------------------------------------------------------------------
local function _fromTheFront(A, iteratee)
    iteratee = jo.iteratee(iteratee)
    local i, length = 1, #A

    while i < length and not jo.isFalsey(iteratee(A[i], i, A)) do
        i = i + 1
    end
    return i - 1
end

-------------------------------------------------------------------------------
local function _fromTheBack(A, iteratee)
    iteratee = jo.iteratee(iteratee)
    local length = #A
    local stoppedAt = length
    for i = length,1,-1 do
        stoppedAt = i
        if jo.isFalsey(iteratee(A[i], i, A)) then break end
    end
    return stoppedAt
end

-------------------------------------------------------------------------------
function array.dropRightWhile(A, iteratee)
    local newLength = _fromTheBack(A, iteratee)
    return array.slice(A, 1, newLength)
end

-------------------------------------------------------------------------------
function array.dropWhile(A, iteratee)
    local start = _fromTheFront(A, iteratee) + 1
    return array.slice(A, start)
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
    for i,tuple in ipairs(A) do
        for n = 1,2 do
            _insert(output, tuple[n])
        end
    end
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
    for i,v in ipairs(A) do
        if predicate(v, i, A) then _insert(output, v) end
    end
    return output
end

-------------------------------------------------------------------------------
function array.find(A, predicate)
    if not A then return nil end
    for i,v in ipairs(A) do
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
-- alias
array.each = array.forEach

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
    array.forEach(A, function(x, k)
        local newKey = predicate(x, k)
        output[newKey] = x
    end)
    return output
end

-------------------------------------------------------------------------------
-- Gets the last element of A.
function array.last(A)
    if not A then return nil end
    return A[#A]
end

-------------------------------------------------------------------------------
-- This method is like _.indexOf except that it iterates over elements of A
-- from right to left.
function array.lastIndexOf(A, value, fromIndex)
    -- todo: use a partial
    local pred = function(x) return value == x end 
    return array.findLastIndex(A, pred, fromIndex)
end

-------------------------------------------------------------------------------
function array.map( A, iteratee )
    local output = {}
    iteratee = jo.iteratee(iteratee)

    for i,v in ipairs(A) do
        _insert(output, iteratee(v, i, A))
    end
    return output
end

-------------------------------------------------------------------------------
-- helper for calculating array positions
local function _arrayPosition(index, length)
    index = math.floor(index)
    if index < 0 then index = index % (length + 1) end
    return index
end

-------------------------------------------------------------------------------
-- Gets the element at index n of A. If n is negative, the nth element 
-- from the end is returned.
function array.nth(A, index)
    if not A then return nil end
    index = _arrayPosition(index, #A)
    return A[index] 
end

-------------------------------------------------------------------------------
-- overwrites A with a shallow copy of B
local function _overWrite(A, B)
    local length = #A
    for i = 1, length do
        A[i] = B[i]
    end
end

-------------------------------------------------------------------------------
-- helper for pull methods
local function _pullAll(A, values, differenceFunc, auxFunc)
    -- todo: performance testing?
    local intermediate = differenceFunc(A, values, auxFunc)
    _overWrite(A, intermediate)
    return A
end

-------------------------------------------------------------------------------
-- Removes all given values from array
-- Note: Unlike _.without, this method mutates array. Use _.remove to remove 
-- elements from an array by predicate.
function array.pull(A, ...)
    return _pullAll(A, {...}, array.difference)
end

-------------------------------------------------------------------------------
-- This method is like _.pull except that it accepts an array of values to 
-- remove. 
-- Note: Unlike _.difference, this method mutates array.
function array.pullAll(A, values)
    return _pullAll(A, values, array.difference)
end

-------------------------------------------------------------------------------
-- This method is like _.pullAll except that it accepts iteratee which is 
-- invoked for each element of array and values to generate the criterion by 
-- which they're compared. The iteratee is invoked with one argument: (value). 
-- Note: Unlike _.differenceBy, this method mutates array.
function array.pullAllBy(A, values, iteratee)
    return _pullAll(A, values, array.differenceBy, iteratee)
end

-------------------------------------------------------------------------------
-- This method is like _.pullAll except that it accepts comparator which is
-- invoked to compare elements of array to values. The comparator is invoked 
-- with two arguments: (arrVal, othVal). 
-- Note: Unlike _.differenceWith, this method mutates array.
function array.pullAllWith(A, values, comparator)
    return _pullAll(A, values, array.differenceWith, comparator)
end

-------------------------------------------------------------------------------
-- Removes elements from array corresponding to indexes and returns an array of
-- removed elements. 
-- Note: Unlike _.at, this method mutates array.
function array.pullAt(A, indices)
    indices = array.keyBy(indices)
    local removed = {}

    local intermediate = array.filter(A, function(x, k)
        if indices[k] then
            _insert(removed, x)
            return false
        end
        return true
    end)
    _overWrite(A, intermediate)
    return removed
end

-------------------------------------------------------------------------------
-- Removes all elements from array that predicate returns truthy for and 
-- returns an array of the removed elements. The predicate is invoked with three
-- arguments: (value, index, array). 
function array.reduce(A, accumulator, predicate)
    for k,v in pairs(A) do
        accumulator = predicate(v, accumulator)
    end

    return accumulator
end

-------------------------------------------------------------------------------
function array.remove(A, iteratee)
    iteratee = jo.iteratee(iteratee)
    local removed = {}
    local intermediate = {}

    array.forEach(A, function(x, k)
        A[k] = nil
        if iteratee(x, k, A) then 
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
-- Reverses array so that the first element becomes the last, the second 
-- element becomes the second to last, and so on. This method mutates the array
function array.reverse(A)
    local length = #A
    local halfLength = math.floor(length/2)

    for i = 1, halfLength do
        A[i], A[length] = A[length], A[i]
        length = length-1
    end

    return A
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
-- Creates a slice of array from startIndex up to and including endIndex
-- Note: Lodash, being javascript, slices from [start, end), but lua is 1-based
-- so it is more logical and consistent to slice from [start, end]
function array.slice(A, startIndex, endIndex)
    local out = {}
    if not A then return out end

    local length = #A
    endIndex = endIndex or length
    startIndex = jo.clamp(_arrayPosition(startIndex, length), length + 1)
    endIndex = jo.clamp(_arrayPosition(endIndex, length), length)

    for i = startIndex, endIndex do
        _insert(out, A[i])
    end

    return out
end

-------------------------------------------------------------------------------
-- helpers for sortedIndexOf
local function _firstIndexOf(A, mid, value, iteratee)
    local index = mid - 1
    while value == iteratee( A[index] ) do
        index = index - 1
    end
    return index + 1
end

local function _lastIndexOf(A, mid, value, iteratee)
    local index = mid + 1
    while value == iteratee( A[index] ) do
        index = index + 1
    end
    return index - 1
end

local function _lastIndex(A, mid, value, iteratee)
    return _lastIndexOf(A, mid, value, iteratee) + 1
end

-------------------------------------------------------------------------------
-- I borrowed this implementation from the internet, there was no license 
-- associated with it, but it was labelled CHILLCODE(tm). I refactored it to 
-- fit the style of the library
local function _sortedIndexOf(A, value, resolver, iteratee)
    if not A then return -1, -1 end
    iteratee = jo.iteratee(iteratee)

    local value = iteratee(value)
    local firstValue = iteratee( A[1] )
    if firstValue and value < firstValue then return 0 end

    local first, last, mid = 1, #A, 0
    while first <= last do
        mid = math.floor( (first+last)/2 )
        local candidate = iteratee( A[mid] )

        if value == candidate then
            return resolver(A, mid, value, iteratee)
        elseif value < candidate then
            last = mid - 1
        else
            first = mid + 1
        end
    end
    return -1, first
end

-------------------------------------------------------------------------------
-- Uses a binary search to determine the lowest index at which value should be
-- inserted into array in order to maintain its sort order.
function array.sortedIndex(A, value)
    local found, index = _sortedIndexOf(A, value, _firstIndexOf)
    return (found ~= -1 and found) or index
end

-------------------------------------------------------------------------------
-- sortedIndex but with iteratee
function array.sortedIndexBy(A, value, iteratee)
    local found, index = _sortedIndexOf(A, value, _firstIndexOf, iteratee)
    return (found ~= -1 and found) or index
end

-------------------------------------------------------------------------------
-- This method is like _.indexOf except that it performs a binary search on a
-- sorted array.
function array.sortedIndexOf(A, value)
    return _sortedIndexOf(A, value, _firstIndexOf)
end

-------------------------------------------------------------------------------
-- This method is like _.sortedIndex except that it returns the highest index 
-- at which value should be inserted into array in order to maintain its sort order.
function array.sortedLastIndex(A, value)
    local found, index = _sortedIndexOf(A, value, _lastIndex)
    return (found ~= -1 and found) or index
end

-------------------------------------------------------------------------------
-- This method is like _.sortedLastIndex except that it accepts iteratee which
-- is invoked for value and each element of array to compute their sort ranking.
-- The iteratee is invoked with one argument: (value).
function array.sortedLastIndexBy(A, value, iteratee)
   local found, index = _sortedIndexOf(A, value, _lastIndex, iteratee)
    return (found ~= -1 and found) or index
end

-------------------------------------------------------------------------------
-- This method is like _.lastIndexOf except that it performs a binary search on
-- a sorted array.
function array.sortedLastIndexOf(A, value)
    return _sortedIndexOf(A, value, _lastIndexOf)
end

-------------------------------------------------------------------------------
-- we do not support this because my implementation of uniq makes it unecessary
function array.sortedUnique()
    assert(false, "just use unique")
end

-------------------------------------------------------------------------------
-- we do not support this because my implementation of uniq makes it unecessary
function array.sortedUniqueBy()
    assert(false, "just use uniqueBy")
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
-- Gets all but the first element of array.
function array.tail(A)
    return array.slice(A, 2)
end

-------------------------------------------------------------------------------
-- Creates a slice of array with n elements taken from the beginning.
function array.take(A, n)
    return array.slice(A, 1, n)
end

-------------------------------------------------------------------------------
-- Creates a slice of array with n elements taken from the beginning.
function array.takeRight(A, n)
    local length = #A
    local start = 1 + length - jo.clamp(n, length)
    return array.slice(A, start, #A)
end

-------------------------------------------------------------------------------
-- Creates a slice of array with elements taken from the end. Elements are
-- taken until predicate returns falsey. The predicate is invoked with three
-- arguments: (value, index, array).
function array.takeRightWhile(A, predicate)
    local start = _fromTheBack(A, predicate) + 1
    return array.slice(A, start)
end

-------------------------------------------------------------------------------
--Creates a slice of array with elements taken from the beginning. Elements are
-- taken until predicate returns falsey. The predicate is invoked with three 
-- arguments: (value, index, array).
function array.takeWhile(A, iteratee)
    local newLength = _fromTheFront(A, iteratee)
    return array.slice(A, 1, newLength)
end

-------------------------------------------------------------------------------
-- helper for union
local function _union(iteratee, args)
    local out = {}
    local test = {}

    local _append = function(x)
        local computed = iteratee(x)
        if not test[computed] then
            _insert(out, x)
            test[computed] = true
        end
    end

    array.forEach(args, function(arg)
        array.forEach(arg, _append)
    end)

    return out
end

-------------------------------------------------------------------------------
-- Creates an array of unique values, in order, from all given arrays
function array.union(...)
    return _union(jo.identity, {...})
end

-------------------------------------------------------------------------------
-- This method is like _.union except that it accepts iteratee which is invoked
-- for each element of each arrays to generate the criterion by which 
-- uniqueness is computed. Result values are chosen from the first array in 
-- which the value occurs. The iteratee is invoked with one argument: (value).
function array.unionBy(...)
    local args = {...}
    local last = jo.private.pullLastIfNotTable(args)
    return _union(jo.iteratee(last), args)
end

-------------------------------------------------------------------------------
-- This method is like _.union except that it accepts comparator which is 
-- invoked to compare elements of arrays. Result values are chosen from the 
-- first array in which the value occurs. The comparator is invoked with two 
-- arguments: (arrVal, othVal).
function array.unionWith(...)
    local out = {}
    local args = {...}
    local comparator = jo.private.pullLastIfFunction(args) 
    comparator = comparator or jo.sameValue

    local _append = function(x)
        for i = 1, #out do
            if comparator(x, out[i]) then return end
        end
        _insert(out, x)
    end

    array.forEach(args, function(arg)
        array.forEach(arg, _append)
    end)

    return out
end

-------------------------------------------------------------------------------
-- calling this series of functions "uniq" instead of "unique" is bullshit, and
-- and I won't do it, and as I specify in the license, we are using a fully
-- open source license with the one exception that you are NOT allowed to call
-- this uniq

-------------------------------------------------------------------------------
-- helper for `unique` and `uniqueBy`
local function _unique(A, iteratee)
    iteratee = jo.iteratee(iteratee)

    local out = {}
    local A_has = array.keyBy(A, iteratee)

    array.forEach(A, function(x)
        local computed = iteratee(x)
        if A_has[computed] then
            _insert(out, x)
            A_has[computed] = nil
        end
    end)

    return out
end

-------------------------------------------------------------------------------
-- Creates a duplicate-free version of an array, in which only the first 
-- occurrence of each element is kept.
function array.unique(A)
   return _unique(A)
end

-------------------------------------------------------------------------------
-- This method is like `unique` except that it accepts iteratee which is 
-- invoked for each element in array to generate the criterion by which 
-- uniqueness is computed. The iteratee is invoked with one argument: (value).
function array.uniqueBy(A, iteratee)
   return _unique(A, iteratee)
end

-------------------------------------------------------------------------------
-- This method is like `unique` except that it accepts comparator which is 
-- invoked to compare elements of array. The comparator is invoked with two 
-- arguments: (arrVal, othVal).
function array.uniqueWith(A, comparator)
    comparator = comparator or jo.sameValue
    local out = {}

    array.forEach(A, function(x)
        if _compareEachWith(x, out, comparator) then return end
        _insert(out, x)
    end)

    return out
end

-------------------------------------------------------------------------------
-- not sure why zip and unzip are separate. zip(zip(A)) = A
-- we are using a sentinel value of jo.UNDEFINED for tuples with holes in them
local function _zip(A, iteratee)
    iteratee = jo.iteratee(iteratee)
    local out = {}
    local first = array.first(A)
    local numTuples = #first
    local inputLength = #A

    for y = 1, numTuples do 
        local row = {}

        for x = 1, inputLength do
            local column = A[x]
            local val = column[y]
            if val ~= nil then 
                row[x] = column[y]
            else 
                row[x] = jo.UNDEFINED
            end
        end

        out[y] = iteratee(row)
    end

    return out
end

-------------------------------------------------------------------------------
-- This method is like `zip` except that it accepts an array of grouped 
-- elements and creates an array regrouping the elements to their pre-zip 
-- configuration.
function array.unzip(A)
   return _zip(A)
end

-------------------------------------------------------------------------------
-- This method is like _.unzip except that it accepts iteratee to specify how
-- regrouped values should be combined. The iteratee is invoked with the 
-- elements of each group.
function array.unzipWith(A, iteratee)
   return _zip(A, iteratee)
end

-------------------------------------------------------------------------------
-- Creates an array excluding all given values.
-- Note: Unlike `pull`, this method returns a new array.
function array.without(A, ...)
    return array.difference(A, ...)
end

-------------------------------------------------------------------------------
-- helper for xor
local function _xor(iteratee, args)
    local out = {}
    local test = {}

    local _count = function(x)
        local computed = iteratee(x)
        test[computed] = (test[computed] or 0) + 1
    end

    local _takeUniques = function(x)
        local computed = iteratee(x)
        if test[computed] ~= 1 then return end
        _insert(out, x)
    end

    for i,arg in ipairs(args) do
        array.forEach(arg, _count)
    end

    for i,arg in ipairs(args) do
        array.forEach(arg, _takeUniques)
    end

    return out
end

-------------------------------------------------------------------------------
-- Creates an array of unique values that is the symmetric difference of the 
-- given arrays. The order of result values is determined by the order they 
-- occur in the arrays.
function array.xor(...)
  return _xor(jo.identity, {...})
end

-------------------------------------------------------------------------------
-- This method is like _.xor except that it accepts iteratee which is invoked
-- for each element of each arrays to generate the criterion by which by which
-- they're compared. The iteratee is invoked with one argument: (value).
function array.xorBy(...)
    local args = {...}
    local last = jo.private.pullLastIfNotTable(args)
    return _xor(jo.iteratee(last), args)
end

-------------------------------------------------------------------------------
-- This method is like _.xor except that it accepts comparator which is invoked
-- to compare elements of arrays. The comparator is invoked with two arguments:
-- (arrVal, othVal).
function array.xorWith(...)
    -- todo
    local args = {...}
    local comparator = jo.private.pullLastIfNotTable(args)
    comparator = comparator or jo.sameValue

    for index, arg in ipairs(args) do
        for i, value in ipairs(arg) do
            
        end
    end
end

-------------------------------------------------------------------------------
-- Creates an array of grouped elements, the first of which contains the first
-- elements of the given arrays, the second of which contains the second
-- elements of the given arrays, and so on.
-- not functionally different from unzip in my implementation
function array.zip(A)
   return _zip(A)
end

-------------------------------------------------------------------------------
function array.zipObject(A)
    -- todo
end


-------------------------------------------------------------------------------
function array.zipObjectDeep(A)
    -- todo
end

-------------------------------------------------------------------------------
-- This method is like _.zip except that it accepts iteratee to specify how 
-- grouped values should be combined. The iteratee is invoked with the elements
-- of each group: (...group).
function array.zipWith(A, iteratee)
   return _zip(A, iteratee)
end

-------------------------------------------------------------------------------
return array
