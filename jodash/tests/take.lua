-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:Take" })

-------------------------------------------------------------------------------
function test.Default(data, userData)
    expect( jo.take(data.ten, 3) ):toMatchArray( {1,2,3} )
end

-------------------------------------------------------------------------------
function test.Empty(data)
    expect( jo.take( {}, 10 ) ):toMatchArray( {} )
end

-------------------------------------------------------------------------------
return test
