-------------------------------------------------------------------------------
local test = deepCopy( require("tests/union") )
test.name = "Array:UnionWith"
test.userData = { func = jo.unionWith }

-------------------------------------------------------------------------------
function test.Comparator(data, userData)
    local left = { {x=1,y=2}, {x=2,y=1} }
    local right = { {x=1,y=2}, {x=4,y=1} }

    local actual = jo.unionWith(left, right, jo.isEqual);
    local expected = {{x=1,y=2}, {x=2,y=1}, {x=4,y=1}}

    expect( actual ):toMatchArray( expected )
end
-------------------------------------------------------------------------------
return test
