-------------------------------------------------------------------------------
-- better assertions
-- copies some implementations from jodash. 
--  *   avoid dependency
--  *   redundancy creates safety when unit testing
-------------------------------------------------------------------------------
local expectation = {}
expectation.__index = function(self, key)
    local v = rawget(expectation, key)

    if type(v) == "function" then
        return function(...)
            assert(v(unpack({...})))
        end
    end

    return rawget(self, key)
end

-------------------------------------------------------------------------------
function expectation:toExist()
    return self.obj ~= nil
end

-------------------------------------------------------------------------------
function expectation:toNotExist()
    return self.obj == nil
end

-------------------------------------------------------------------------------
function expectation:toBe(rhs)
    return self.obj == rhs
end

-------------------------------------------------------------------------------
function expectation:toNotBe(rhs)
    return self.obj ~= rhs
end

-------------------------------------------------------------------------------
function expectation:toBeA(thing)
    if type(thing) == "table" then
        return getmetatable(self.obj) == classDef
    elseif type(thing) == "string" then
        return type(self.obj) == thing
    end
end

-------------------------------------------------------------------------------
expectation.toBeAn = expectation.toBeA

-------------------------------------------------------------------------------
function expectation:toNotBeA(thing)
    return not self:toBeA(thing)
end

-------------------------------------------------------------------------------
expectation.toNotBeAn = expectation.toNotBeA

-------------------------------------------------------------------------------
function expectation:toBeLessThan(rhs)
    return self.obj < rhs
end

-------------------------------------------------------------------------------
function expectation:toBeLessThanOrEqualTo(rhs)
    return self.obj <= rhs
end

-------------------------------------------------------------------------------
function expectation:toBeGreaterThan(rhs)
    return self.obj > rhs
end

-------------------------------------------------------------------------------
function expectation:toBeGreaterThanOrEqualTo(rhs)
    return self.obj >= rhs
end

-------------------------------------------------------------------------------
local function isEqual(lhs, rhs) return lhs == rhs end

-------------------------------------------------------------------------------
function expectation:toInclude(needle, comparator)
    comparator = comparator or isEqual
    for k,v in pairs(self.obj) do
        if comparator(v, needle) then return true end
    end

    return false
end

-------------------------------------------------------------------------------
expectation.toContain = expectation.toInclude

-------------------------------------------------------------------------------
function expectation:toExclude(needle, comparator)
    return not self:toInclude(needle, comparator)
end

-------------------------------------------------------------------------------
expectation.toNotContain = expectation.toExclude
expectation.toNotInclude = expectation.toExclude

-------------------------------------------------------------------------------
function expectation:toIncludeKey(needle, comparator)
    comparator = comparator or isEqual
    -- copies the implementation from jodash. No dependency, and redundancy 
    -- creates safety in this case
    for k,v in pairs(self.obj) do
        if comparator(k, needle) then return true end
    end

    return false
end

-------------------------------------------------------------------------------
expectation.toContainKey = expectation.toIncludeKey

-------------------------------------------------------------------------------
function expectation:toIncludeKeys(keys, comparator)
    for k, v in pairs(keys) do
        -- O(n^2). todo
        if not self:toIncludeKey(v) then return false end
    end

    return true
end

-------------------------------------------------------------------------------
expectation.toContainKeys = expectation.toIncludeKeys

-------------------------------------------------------------------------------
function expectation:toExcludeKey(needle, comparator)
    return not self:toIncludeKey(needle, comparator)
end

-------------------------------------------------------------------------------
expectation.toNotContainKey = expectation.toExcludeKey
expectation.toNotIncludeKey = expectation.toExcludeKey

-------------------------------------------------------------------------------
function expectation:toNotIncludeKeys(keys, comparator)
    return not self:toIncludeKeys(keys, comparator)
end

-------------------------------------------------------------------------------
expectation.toNotContainKeys = expectation.toExcludeKeys
expectation.toNotIncludeKeys = expectation.toExcludeKeys

-------------------------------------------------------------------------------
-- a couple of extensions of my own
-------------------------------------------------------------------------------
function expectation:toBeEmpty(...)
    return type(self.obj) == "table" and next(self.obj) == nil
end

-------------------------------------------------------------------------------
function expectation.toMatchArray(rhs, comparator)
    comparator = comparator or isEqual
    for k,v in pairs(self.obj) do
        if not comparator(rhs[k], v) then return false end
    end

    for k,v in pairs(rhs) do
        if not self.obj[k] then return false end
    end

    return true
end

-------------------------------------------------------------------------------
return function(obj)
    local out = { obj = obj }
    setmetatable(out, expectation)
    return out
end
