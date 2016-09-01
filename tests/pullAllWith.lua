-------------------------------------------------------------------------------
local test = deepCopy( require("tests/pullAll") )
test.name = "Array:PullAllWith"
test.userData = { func = jo.pullAllWith }

-------------------------------------------------------------------------------
function test.Comparator(data, userData)
    local input = { {x=1,y=2}, {x=2,y=1} }
    local actual = jo.pullAllWith(input, { {x=2,y=1} }, jo.isEqual);

    expect( actual ):toBe( input )
    expect( actual ):toMatchArray( {{x=1,y=2}} )
end

-------------------------------------------------------------------------------
return test
