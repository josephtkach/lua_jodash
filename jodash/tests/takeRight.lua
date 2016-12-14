-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:TakeRight" })

-------------------------------------------------------------------------------
function test.Default(data, userData)
    expect( jo.takeRight(data.ten, 3) ):toMatchArray( {8,9,10} )
end

-------------------------------------------------------------------------------
function test.TooManyCooks(data, userData)
    expect( jo.takeRight({1,2,3}, 7) ):toMatchArray( {1,2,3} )
end

-------------------------------------------------------------------------------
function test.Empty(data)
    expect( jo.take( {}, 10 ) ):toMatchArray( {} )
end

-------------------------------------------------------------------------------
return test
