-------------------------------------------------------------------------------
-- difference tests
local test = deepCopy( require("tests/difference") )
test.name = "Array:DifferenceBy"
test.userData = { func = jo.differenceBy }

-------------------------------------------------------------------------------
function test.Iteratee(data, userData)
    local actual = jo.differenceBy({2.1,1.2}, {2.3,3.4}, math.floor)
    local expected = {1.2}
    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
function test.propertyShorthand(data, userData)
    local actual = jo.differenceBy({ {x=2}, {x=1} }, {{x=1}}, 'x')
    local expected = { {x=2} }

    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
return test
