-------------------------------------------------------------------------------
local test = deepCopy( require("tests/intersection") )
test.name = "Array:IntersectionWith"
test.userData = { func = jo.intersectionWith }

-------------------------------------------------------------------------------
function test.Comparator(data, userData)
    local objects = { {x=1,y=2}, {x=2,y=1} }
    local actual = jo.intersectionWith(objects, { {x=2,y=1} }, jo.isEqual);
    local expected = {{x=2,y=1}}
    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
return test
