-------------------------------------------------------------------------------
-- test data for harness
local exports = {}
-------------------------------------------------------------------------------
-- todo: make a factory for objects of this type
setmetatable(exports, { __index = function(self, key)
    return deepCopy(rawget(self, key))
end })

-------------------------------------------------------------------------------
exports.empty = {}

-------------------------------------------------------------------------------
exports.alphabet = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' }

-------------------------------------------------------------------------------
exports.ten = {}
for i = 1,10 do
    exports.ten[i] = i
end

-------------------------------------------------------------------------------
exports.allFalseys = { "", 0, false }
exports.falseyAndTruthy = { "", "foo", 0, 1, false, true, exports.empty }
exports.onlyTruthy = { "foo", 1, true, exports.empty }

-------------------------------------------------------------------------------
return exports
