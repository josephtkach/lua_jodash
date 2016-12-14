-------------------------------------------------------------------------------
local test = deepCopy( require("tests/unique") )
test.name = "Array:UniqueBy"
test.userData = { func = jo.uniqueBy }

-------------------------------------------------------------------------------
function test.Iteratee(data, userData)
    local actual = jo.uniqueBy({2.1,1.2,2.4,2.7,1.5}, math.floor)
    local expected = {2.1,1.2}
    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
function test.propertyShorthand(data, userData)
    local actual = jo.uniqueBy({ {x=2}, {x=1}, {x=1}, {x=1} }, 'x')
    local expected = { {x=2}, {x=1} }

    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
return test
