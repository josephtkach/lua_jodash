-------------------------------------------------------------------------------
local test = deepCopy( require("tests/sortedIndex") )
test.name = "Array:SortedLastIndex"
test.userData = { func = jo.sortedLastIndex }

-------------------------------------------------------------------------------
function test.ValueAlreadyPresent(data, userData)
    expect( userData.func(data.ten, 7) ):toBe( 8 )
end

-------------------------------------------------------------------------------
return test
