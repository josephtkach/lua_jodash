-------------------------------------------------------------------------------
-- difference tests
local test = deepCopy( require("tests/difference") )
test.name = "Array:DifferenceWith"
test.userData = { func = jo.differenceWith }

-------------------------------------------------------------------------------
function test.Comparator(data, userData)
    local objects = { {x=1,y=2}, {x=2,y=1} }
    local actual = jo.differenceWith(objects, { {x=2,y=1} }, jo.isEqual);
    local expected = {{x=1,y=2}}
    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
return test
