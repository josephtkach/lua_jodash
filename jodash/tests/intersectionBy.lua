-------------------------------------------------------------------------------
local test = deepCopy( require("tests/intersection") )
test.name = "Array:IntersectionBy"
test.userData = { func = jo.intersectionBy }

-------------------------------------------------------------------------------
function test.Iteratee(data, userData)
    local actual = jo.intersectionBy({2.1,1.2}, {2.3,3.4}, math.floor)
    local expected = {2.1}
    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
function test.propertyShorthand(data, userData)
    local actual = jo.intersectionBy({ {x=2}, {x=1} }, {{x=1}}, 'x')
    local expected = { {x=1} }

    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
return test
