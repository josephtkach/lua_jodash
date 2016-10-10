-------------------------------------------------------------------------------
local test = deepCopy( require("tests/xor") )
test.name = "Array:XorBy"
test.userData = { func = jo.xorBy }

-------------------------------------------------------------------------------
function test.Iteratee(data, userData)
    local actual = jo.xorBy({2.1,1.2}, {2.3,3.4}, math.floor)
    local expected = {1.2, 3.4}
    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
function test.propertyShorthand(data, userData)
    local actual = jo.xorBy({ {x=2}, {x=1} }, { {x=1}, {x=3} }, 'x')
    local expected = { {x=2}, {x=3} }

    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
return test
