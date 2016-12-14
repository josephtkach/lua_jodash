-------------------------------------------------------------------------------
-- chunk tests
local test = junit:new({ name = "Array:FlattenDeep" })

-------------------------------------------------------------------------------
function test.Default(data)
    expect( jo.flattenDeep({ 1, 2, {3, {4}, 5}, 6, {{{7}}} }) )
        :toMatchArray( {1, 2, 3, 4, 5, 6, 7 } )
end

-------------------------------------------------------------------------------
function test.Empty(data)
    expect( jo.flattenDeep({}) )
        :toMatchArray( {} )
end

-------------------------------------------------------------------------------
function test.Object(data)
    local expected = {1, 2, {foo="bar"}, 4}
    expect( jo.flattenDeep(expected) )
        :toMatchArray( expected )
end

-------------------------------------------------------------------------------
return test
