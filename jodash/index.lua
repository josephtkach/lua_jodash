-------------------------------------------------------------------------------
-- functional.lua
-- a lua functional library by Joseph Tkach
-- those with strong opinions about the academic definition of "functional"
-- should probably avert their eyes; it is meant to be practical, not pedantic
-------------------------------------------------------------------------------
local set = {}
set.__index = set

-------------------------------------------------------------------------------
-- hash and array need different implementations
local arraySet = require("jodash/array")
local hashSet = require("jodash/hash")

-------------------------------------------------------------------------------
local function isArray(A)
    if A == nil then return false end
    if #A == 0 then
        for k,v in pairs(A) do
            return false
        end
    end

    return true
end

-------------------------------------------------------------------------------
local function getInvoker(key)
    return function(A, ...)
         -- hook if possible
        if getmetatable(A) == nil then
            setmetatable(A, set)
        end
        -- get appropriate metatable for data structure
        local mt = arraySet
        if not isArray(A) then
            mt = hashSet 
        end

        local func = mt[key] or rawget(A, key)

        local count = select("#", ...)
        if count == 0 then return func(A) end
        return func(A, unpack({...}))
    end
end

-------------------------------------------------------------------------------
setmetatable(set, {
    __index = function(self, key)
        return rawget(self, key) or getInvoker(key)
    end
})

-------------------------------------------------------------------------------
function set.identity(x)
    return x
end

-------------------------------------------------------------------------------
local _preds = {}
_preds["function"] = set.identity
_preds["table"] = function(arg) 
    return function(x)
        return x == arg or set.contains(arg, x)
    end
end

-------------------------------------------------------------------------------
local function predicateFromArgument(arg)
    local t = type(arg)
    local pred = _preds[t] 
    if pred then return pred(arg) end
    return set.filters.is(arg)
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
function set.new(A)
    local newSet
    if A then 
        newSet = deepCopy(A)
    else 
        newSet = {}
    end

    if getmetatable(newSet) ~= nil then
        print(" ")
        print("WARNING: Tried to convert a table with a non-nil metatable to a set")
        print(debug.traceback())
    end
    setmetatable(newSet, set)
    return newSet
end

-------------------------------------------------------------------------------
function set.shallowCopy(A)
    local out = set.new()
    for k,v in pairs(A) do
        out[k] = v
    end
    return out
end

-------------------------------------------------------------------------------
function set.plainOldData(A)
    setmetatable(A, nil)
    return A
end

-------------------------------------------------------------------------------
local vprint = function(verbose, msg)
    if verbose then printSmart(msg) end
end
-------------------------------------------------------------------------------
function set.get(object, path, default, verbose)
    local paths = path:split('.')
    for i,v in ipairs(paths) do
        if not isTable(object) then 
            vprint(verbose, "\tearly return")
            return default 
        end
        object = object[v]
        vprint(verbose, "dereferenced " .. v)
        vprint(verbose, object)
    end

    vprint(verbose, object)
    -- we must do this check or we will be unable to obtain a falsey value
    if object == nil then return default end
    return object
end

-------------------------------------------------------------------------------
function set.size(A)
    if set.isArray(A) then
        return #A 
    else 
        return hashSize(A) 
    end
end

-------------------------------------------------------------------------------
local function modularCount(A, count)
    local length = set.size(A)

    if count < 0 then
        count = count % #A
    end

    if count == 0 then 
        count = #A
    end

    return count
end

-------------------------------------------------------------------------------
function set.nth(A, index, action)
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
function set.last(A)
    -- assumes a continuous array
    if not A then return nil end
    return A[#A]
end

-------------------------------------------------------------------------------
function set.each( A, predicate )
    if not A then return nil end
    hookIfPossible(A)

    local iter = pairs
    if set.isArray(A) then iter = ipairs end

    for k,v in iter(A) do
        predicate(v, k, A)
    end
    return A
end

-------------------------------------------------------------------------------
function set.contains(A, x)
    for k,xPrime in pairs(A) do
        if x == xPrime then return true end
    end

    return false
end

------------------------------------------------------------------------------------------
function set.find(A, predicate)
    if A then
        for k,v in pairs(A) do
            if predicate(v) then return v end
        end
    end
    return nil
end

-------------------------------------------------------------------------------
function set.isEmpty(A)
    return not A or next(A) == nil
end

-------------------------------------------------------------------------------
function set.print(A, label)
    if not A then return end
    if label then print(label) end
    printTable(A, 99)
    return A
end

-------------------------------------------------------------------------------
function set.randomFromRangeInSet(A, min, max)
    if not A then return nil end

    local index = min
    if min < max then
        index = math.random(min, max)
    end

    if not set.isArray(A) then
        print("PERFORMANCE WARNING: You are trying to pull values from random numerical indices in a hash map. this is SLOW")
        return set.nth(index)
    end

    return A[index] or print("WARNING: invalid range supplied to randomFromRangeInSet")
end

-------------------------------------------------------------------------------
function set.randomFrom(A)
    return set.randomFromRangeInSet(A, 1, #A)
end

-------------------------------------------------------------------------------
-- optimization
local function append(A, x)
    A[#A+1] = x
    return A
end

-------------------------------------------------------------------------------
function set.append(A, x)
    if not A then A = {} end
    hookIfPossible(A)
    return append(A, x) 
end

-------------------------------------------------------------------------------
function set.limit_inPlace(A,count)
    if A then
        local start = modularCount(A,count)
        for i = start,#A do
            A[i] = nil
        end
    end
    
    return A
end

-------------------------------------------------------------------------------
function set.splat(count, value)
    local A = set.new()
    for i = 1,count do
        append(A, value)
    end
    return A
end

-------------------------------------------------------------------------------
function set.limit(A, count)
    if not A then return A end
    local output = set.new()

    count = modularCount(A,count)
    
    for i = 1, count do
        if not A[i] then return output end
        append(output, A[i])
    end

    return output
end

-------------------------------------------------------------------------------
function set.keys(A)
    local output = set.new()
    for k,v in pairs(A) do
        append(output, k)
    end
    return output
end

-------------------------------------------------------------------------------
function set.values(A)
    local output = set.new()
    for k,v in pairs(A) do
        append(output, v)
    end
    return output
end

-------------------------------------------------------------------------------
function set.reverseKVP(A)
    local output = set.new()
    for k,v in pairs(A) do output[v] = k end
    return output
end

-------------------------------------------------------------------------------
function set.reverseLookup(A, value)
    if not A then return end
    for k,v in pairs(A) do
        if v == value then return k end
    end
    return nil
end

-------------------------------------------------------------------------------
function set.map( A, predicate )
    local output = set.new()
    local pred = nil

    if set.isArray(A) then
        pred = function(v, k) append(output, predicate(v, k)) end
    else
        pred = function(v, k) output[k] = predicate(v, k) end
    end

    set.each(A, pred)
    return output
end

-------------------------------------------------------------------------------
function set.remap( A, predicate )
    local output = set.new()
    set.each(A, function(oldValue, oldKey)
        local newValue, newKey = predicate(oldValue, oldKey)
        output[newKey] = newValue
    end)
    return output
end

-------------------------------------------------------------------------------
function set.pluck( A, path )
    return set.map(A, function(x)
        return set.get(x, path)
    end)
end

-------------------------------------------------------------------------------
function set.filter( A, predicate )
    local output = set.new()
    set.each(A, function(x, k)
        if predicate(x, k) then output[k] = x end
    end)
    return output
end

-------------------------------------------------------------------------------
function arraySet.remove(A, predicate)
    local removed = set.new()
    local intermediate = {}

    set.each(A, function(x, k)
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
function hashSet.remove(A, predicate)
    local removed = set.new()

    set.each(A, function(x, k)
        if not predicate(x, k) then 
            A[k] = nil
            removed[k] = x
        end
    end)
    return removed
end

-------------------------------------------------------------------------------
function set.concatenate(A, B)
    if not A then A = set.new() end
    if not B then return A end
    set.each(B, function(x) append(A, x) end)
    return A
end

-------------------------------------------------------------------------------
local function concatenateKVP_inner(A, B, allowOverwrite)
    if not A then A = set.new() end
    if not B then return A end
    
    set.each(B, function(v, k)
        local rhs = A[k]
        if rhs then
            if isTable(rhs) then
                A[k] = concatenateKVP_inner(v, rhs, allowOverwrite)
            else
                if not allowOverwrite then
                    print("\nWARNING: Overwrote key " .. k .. " in set.concatenateKVP") 
                end
                A[k] = v 
            end
        else
            A[k] = v 
        end
    end)

    return A
end

-------------------------------------------------------------------------------
function set.concatenateKVP(A, B, allowOverwrite)
    return concatenateKVP_inner(A, B, allowOverwrite)
end

-------------------------------------------------------------------------------
function set.union(A, B)
    local output = set.new()
    set.concatenate(output, A)
    set.concatenate(output, B)
    return output
end

-------------------------------------------------------------------------------
function set.unionKVP(A, B)
    local output = set.new()
    set.concatenateKVP(output, A)
    set.concatenateKVP(output, B)
    return output
end

-------------------------------------------------------------------------------
function set.unionKVPwithOverwrite(A, B)
    local output = set.new()
    set.concatenateKVP(output, A, true)
    set.concatenateKVP(output, B, true)
    return output
end

-------------------------------------------------------------------------------
function set.valuesAsKeys(A, newValue)
    if newValue == nil then newValue = true end
    local output = {}
    set.each(A, function(x)
        output[x] = newValue
    end)
    return output
end

-------------------------------------------------------------------------------
function set.distinct( A )
    local A_has = set.valuesAsKeys(A)
    return set.keys(A_has)
end

-------------------------------------------------------------------------------
function set.intersection(A, B)
    local output = set.new()
    local B_has = set.valuesAsKeys(B)
    
    set.each(A, function(x) 
        if B_has[x] then
             append(output, x) 
        end 
    end)

    return output
end

-------------------------------------------------------------------------------
function set.relativeComplement(A, B)   -- the set of all B not in A
    local output = set.new()
    local A_has = set.valuesAsKeys(A)
    
    set.each(B, function(x) 
        if A_has[x] == nil then
             append(output, x) 
        end 
    end)

    return output
end

-------------------------------------------------------------------------------
function set.relativeComplementKVP(A, B)    -- the set of all B not in A
    local output = set.new()

    set.each(B, function(v, k)
        if A[k] == nil then
            output[k] = v
        end
    end)

    return output
end

-------------------------------------------------------------------------------
function set.reduce(A, accumulator, predicate)
    for k,v in pairs(A) do
        accumulator = predicate(v, accumulator)
    end

    return accumulator
end

-------------------------------------------------------------------------------
-- some ultra-common predicates
set.predicates = {}
set.predicates.executeAll = function(x) x() end

set.reductors = {}
set.reductors.add = function(v, accumulator) return v + accumulator end
set.reductors.booleanAnd = function(v, accumulator) return v and accumulator end
set.reductors.booleanOr = function(v, accumulator) return v or accumulator end

set.filters = {}
set.filters.nonEmptyString = function(entry) return not isEmptyStr(entry) end
set.filters.containsText = function(value) return function(entry) return entry:find(value) end end
set.filters.doesNotContainText = function(value) return function(entry) return not (nil == entry:find(value)) end end
set.filters.is = function(value) return function(entry) return value == entry end end
set.filters.isNot = function(value) return function(entry) return value ~= entry end end

-------------------------------------------------------------------------------
function set.tostring(A, delimiter)
    delimiter = delimiter or ", "

    local out = ""
    if #A > 1 then
        out = set.reduce(set.limit(A, -1), out, function(x, accumulator)
            return accumulator .. x .. delimiter
        end)
    end

    return out .. set.last(A)
end

-------------------------------------------------------------------------------
-- syntactic sugar
set.isArray = isArray
set.unique = set.distinct
set.count = set.size
set.length = set.size
set.truncate = set.limit
set.truncate_inPlace = set.limit_inPlace
set.first = function(A, action) return set.nth(A, 1, action ) end

-- noop for compatibility with Message.Reader
set.marshal = function(A) return A end



--------------------------------------------------------------------------------
local function index(self, key)
    local mt = getmetatable(self)
    return mt.original[key]
end

--------------------------------------------------------------------------------
local function replaceWithProxy(object, newindex)
    local original = {}
    for k,v in pairs(object) do
        original[k] = v
        object[k] = nil
    end
    setmetatable(original, getmetatable(object))

    ----------------------------------------------------------------------------
    setmetatable(object, { 
        readonly = true, 
        original = original, 
        __index = index, 
        __newindex = newindex
    })
end

--------------------------------------------------------------------------------
--  options: 
--      recursive - create the proxy recursively
function set.watch(object, field, options)
    print("setting a watch on " .. tostring(object) .. "." .. tostring(field))
    local function watchNewIndex(self, key, value)
        if not field or key == field then
            local oldValue = rawget(getmetatable(object).original, key)
            warn("modified key: " .. key .. " on table: " .. tostring(self)
                .. "\nold value: " .. tostring(oldValue)
                .. "\nnew value: " .. tostring(value))
        end
        rawset(getmetatable(object).original, key, value)
    end

    replaceWithProxy(object, watchNewIndex)
end

-------------------------------------------------------------------------------
return set