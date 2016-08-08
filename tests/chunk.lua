-------------------------------------------------------------------------------
-- chunk tests
local test = junit:new({ name = "Array:Chunk" })

-------------------------------------------------------------------------------
function test.Empty(data)
    expect( jo.chunk(data.empty) ):toBeEmpty()
end

-------------------------------------------------------------------------------
function test.SizeInvalid(data)
    expect( jo.chunk(data.ten, -1) ):toMatchArray({ {1},{2},{3},{4},{5},{6},{7},{8},{9},{10} })
end

-------------------------------------------------------------------------------
function test.Size1(data)
    expect( jo.chunk(data.ten, 1) ):toMatchArray({ {1},{2},{3},{4},{5},{6},{7},{8},{9},{10} })
end

-------------------------------------------------------------------------------
function test.Size2(data)
    expect( jo.chunk(data.ten, 2) ):toMatchArray({ {1,2}, {3,4}, {5,6}, {7,8}, {9,10} })
end

-------------------------------------------------------------------------------
function test.Size4(data)
    expect( jo.chunk(data.ten, 4) ):toMatchArray({ {1,2,3,4}, {5,6,7,8}, {9,10} })
end

-------------------------------------------------------------------------------
function test.Size10(data)
    expect( jo.chunk(data.ten, 10) ):toMatchArray( { data.ten } )
end

-------------------------------------------------------------------------------
function test.Size20(data)
    expect( jo.chunk(data.ten, 20) ):toMatchArray( { data.ten } )
end

-------------------------------------------------------------------------------
return test
