-------------------------------------------------------------------------------
local test = deepCopy( require("tests/sortedLastIndex") )
test.name = "Array:SortedLastIndexBy"
test.userData = { func = jo.sortedLastIndexBy }

-------------------------------------------------------------------------------
function test.propertyShorthand(data, userData)
    local actual = userData.func({ {x=1},{x=3} }, {x=3}, 'x')

    expect( actual ):toBe( 3 )
end

-------------------------------------------------------------------------------
return test
