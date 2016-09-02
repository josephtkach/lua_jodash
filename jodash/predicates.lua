-------------------------------------------------------------------------------
local jo = __

-------------------------------------------------------------------------------
-- some common predicates
jo.predicates = {}
jo.predicates.executeAll = function(x) x() end

jo.reductors = {}
jo.reductors.add = function(x, accumulator) return x + accumulator end
jo.reductors.booleanAnd = function(x, accumulator) return x and accumulator end
jo.reductors.booleanOr = function(x, accumulator) return x or accumulator end

jo.filters = {}
jo.filters.nonEmptyString = function(entry) return not isEmptyStr(entry) end
jo.filters.containsText = function(value) return function(entry) return entry:find(value) end end
jo.filters.doesNotContainText = function(value) return function(entry) return not (nil == entry:find(value)) end end
jo.filters.is = function(value) return function(entry) return value == entry end end
jo.filters.isNot = function(value) return function(entry) return value ~= entry end end
