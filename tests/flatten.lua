-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:Flatten" })

-------------------------------------------------------------------------------
function test.Default(data)
    expect( jo.flatten({1, 2, {3, {4}, 5}, 6, {{{7}}} }) )
        :toMatchArray( {1, 2, 3, {4}, 5, 6, {{7}} } )
end

-------------------------------------------------------------------------------
function test.Empty(data)
    expect( jo.flatten({}) )
        :toMatchArray( {} )
end

-------------------------------------------------------------------------------
function test.Object(data)
    local input = {1, 2, {foo="bar"}, 4}
    expect( jo.flatten(input) )
        :toMatchArray( input )
end

-------------------------------------------------------------------------------
return test
