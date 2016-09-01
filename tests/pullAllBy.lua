-------------------------------------------------------------------------------
local test = deepCopy( require("tests/pullAll") )
test.name = "Array:PullAllBy"
test.userData = { func = jo.pullAllBy }

-------------------------------------------------------------------------------
function test.Iteratee(data, userData)
    local input = { 1.1, 2.4, 1.3, 2.6, 2.9 }
    local actual = jo.pullAllBy(input, {1}, math.floor)

    expect( actual ):toBe( input )
    expect( actual ):toMatchArray( { 2.4, 2.6, 2.9 } )
end


-------------------------------------------------------------------------------
function test.propertyShorthand(data, userData)
    local input = { {x=2}, {x=1} }
    local actual = jo.pullAllBy(input, {{x=1}}, 'x')

    expect( actual ):toBe( input )
    expect( actual ):toMatchArray( { {x=2} } )
end

-------------------------------------------------------------------------------
return test
