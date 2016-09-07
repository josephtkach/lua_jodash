-------------------------------------------------------------------------------
local test = deepCopy( require("tests/sortedIndex") )
test.name = "Array:SortedIndexBy"
test.userData = { func = jo.sortedIndexBy }

-------------------------------------------------------------------------------
function test.propertyShorthand(data, userData)
    local actual = jo.sortedIndexBy({ {x=1},{x=3} }, {x=2}, 'x')

    expect( actual ):toBe( 2 )
end

-------------------------------------------------------------------------------
return test
