-------------------------------------------------------------------------------
local test = deepCopy( require("tests/pull") )
test.name = "Array:PullAll"
test.userData = { func = function(A, ...)
    return jo.pullAll(A, {...})
end }

return test
