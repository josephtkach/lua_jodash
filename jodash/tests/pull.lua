-------------------------------------------------------------------------------
local test = deepCopy( require("tests/pullAll") )
test.name = "Array:Pull"
test.userData = { func = function(A, values)
    return jo.pull(A, table.unpack(values))
end }

-------------------------------------------------------------------------------
return test
