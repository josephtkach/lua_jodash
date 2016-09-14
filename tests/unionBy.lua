-------------------------------------------------------------------------------
local test = deepCopy( require("tests/union") )
test.name = "Array:UnionBy"
test.userData = { func = jo.unionBy }

-------------------------------------------------------------------------------
function test.Iteratee(data, userData)
    local actual = jo.unionBy({2.1,1.2}, {2.3,3.4}, math.floor)
    local expected = {2.1, 1.2, 3.4}
    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
function test.propertyShorthand(data, userData)
    local actual = jo.unionBy({ {x=2}, {x=1} }, {{x=1}, {x=3}}, 'x')
    local expected = { {x=2}, {x=1}, {x=3} }

    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
return test
