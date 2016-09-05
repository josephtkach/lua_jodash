-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:Slice" })

-------------------------------------------------------------------------------
function test.Default(data, userData)
    expect( jo.slice(data.ten, 3, 7) ):toMatchArray( {3,4,5,6,7 } )
end

-------------------------------------------------------------------------------
function test.Empty(data)
    expect( jo.slice( {}, 1, 10) ):toMatchArray( {} )
end

-------------------------------------------------------------------------------
function test.OutOfBounds(data)
    expect( jo.slice(data.ten, 0, math.huge) ):toMatchArray( data.ten )
end

-------------------------------------------------------------------------------
function test.CoerceFloats(data)
    expect( jo.slice(data.ten, 3.4, 7.5) ):toMatchArray( {3,4,5,6,7 } )
end

-------------------------------------------------------------------------------
return test
