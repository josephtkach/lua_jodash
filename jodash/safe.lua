-------------------------------------------------------------------------------
local jo = __
-------------------------------------------------------------------------------
-- define a fault-tolerant object
-------------------------------------------------------------------------------
jo.noop = function() end

-------------------------------------------------------------------------------
local function mathNoop(lhs, rhs)
    if isNumber(lhs) then return lhs
    elseif isNumber(rhs) then return rhs
    else return 0 end
end

-------------------------------------------------------------------------------
local function stringNoop(lhs, rhs)
    return tostring(lhs) .. tostring(rhs)
end

-------------------------------------------------------------------------------
faultTolerantObject = {}
setmetatable(faultTolerantObject, {
    __call = function() return faultTolerantObject end,
    __add = mathNoop,
    __sub = mathNoop,
    __div = mathNoop,
    __mul = mathNoop,
    __pow = mathNoop,
    __unm = mathNoop,
    __concat = stringNoop,
    __len = function() return 0 end,
    __le = function() return false end,
    __lt = function() return false end,
    __index = function(self, key) return self end,
    __newindex = noop,
})

-------------------------------------------------------------------------------
function jo.safe(value)
    return value or faultTolerantObject
end

-------------------------------------------------------------------------------
function jo.safeToCall(value)
    return (jo.isFunction(value) and value) or faultTolerantObject
end
