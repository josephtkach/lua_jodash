-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:Initial" })

-------------------------------------------------------------------------------
function test.Default(data)
    expect( jo.initial( {1, 2, 3,} ) )
        :toMatchArray( {1, 2} )
end

-------------------------------------------------------------------------------
function test.Empty(data)
    expect( jo.initial( data.empty ) )
        :toMatchArray( data.empty )
end

-------------------------------------------------------------------------------
return test
