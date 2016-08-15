-------------------------------------------------------------------------------
-- chunk tests
local test = junit:new({ name = "Array:DropRight" })

-------------------------------------------------------------------------------
function test.Default(data)
    expect( jo.dropRight({1,2,3}) ):toMatchArray( {1,2} )
end

-------------------------------------------------------------------------------
function test.Drop2(data)
    expect( jo.dropRight({1,2,3},2) ):toMatchArray( {1} )
end

-------------------------------------------------------------------------------
function test.Drop5(data)
    expect( jo.dropRight({1,2,3},5) ):toMatchArray( {} )
end

-------------------------------------------------------------------------------
function test.Drop0(data)
    expect( jo.dropRight({1,2,3},0) ):toMatchArray( {1,2,3} )
end

-------------------------------------------------------------------------------
return test
