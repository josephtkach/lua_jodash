-------------------------------------------------------------------------------
-- some common predicates
jo.predicates = {}
jo.predicates.executeAll = function(x) x() end

jo.reductors = {}
jo.reductors.add = function(v, accumulator) return v + accumulator end
jo.reductors.booleanAnd = function(v, accumulator) return v and accumulator end
jo.reductors.booleanOr = function(v, accumulator) return v or accumulator end

jo.filters = {}
jo.filters.nonEmptyString = function(entry) return not isEmptyStr(entry) end
jo.filters.containsText = function(value) return function(entry) return entry:find(value) end end
jo.filters.doesNotContainText = function(value) return function(entry) return not (nil == entry:find(value)) end end
jo.filters.is = function(value) return function(entry) return value == entry end end
jo.filters.isNot = function(value) return function(entry) return value ~= entry end end
