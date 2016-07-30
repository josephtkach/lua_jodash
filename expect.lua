-------------------------------------------------------------------------------
-- better assertions
-------------------------------------------------------------------------------
local expectation = {}
expectation.__index = expectation

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
    -- copies the implementation from jodash. No dependency, and redundancy 
    -- creates safety in this case
    for k,v in pairs(self.obj) do
        if comparator(v, needled) then return true end
    end

    return false
end

-------------------------------------------------------------------------------
expectation.toContain = expectation.toInclude

-------------------------------------------------------------------------------
function expectation:toExclude(needle, comparator)
    return not self:toInclude(needled, comparator)
end

-------------------------------------------------------------------------------
expectation.toNotContain = expectation.toExclude
expectation.toNotInclude = expectation.toExclude


-------------------------------------------------------------------------------
function expect(obj) 
    local out = {}
    out.obj = obj
    setmetatable(out, e)
    return out
end

