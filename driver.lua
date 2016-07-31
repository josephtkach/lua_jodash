-------------------------------------------------------------------------------
-- test driver for jodash
-------------------------------------------------------------------------------
local junit = require("junit/index")
local expect = require("junit/expect")

local jo = require("jodash/index")

-------------------------------------------------------------------------------
-- array tests
local ArrayTests = junit:new({ name = "Array" })

-------------------------------------------------------------------------------
function ArrayTests.chunkEmpty(data)
    expect( jo.chunk(data.empty) ):toBeEmpty()
end

-------------------------------------------------------------------------------
function ArrayTests.chunkSizeInvalid(data)
    expect( jo.chunk(data.ten, -1) ):toMatchArray({ {1},{2},{3},{4},{5},{6},{7},{8},{9},{10} })
end

-------------------------------------------------------------------------------
function ArrayTests.chunkSize1(data)
    expect( jo.chunk(data.ten, 1) ):toMatchArray({ {1},{2},{3},{4},{5},{6},{7},{8},{9},{10} })
end

-------------------------------------------------------------------------------
function ArrayTests.chunkSize2(data)
    expect( jo.chunk(data.ten, 2) ):toMatchArray({ {1,2}, {3,4}, {5,6}, {7,8}, {9,10} })
end

-------------------------------------------------------------------------------
function ArrayTests.chunkSize4(data)
    expect( jo.chunk(data.ten, 4) ):toMatchArray({ {1,2,3,4}, {5,6,7,8}, {9,10} })
end

-------------------------------------------------------------------------------
function ArrayTests.chunkSize10(data)
    expect( jo.chunk(data.ten, 10) ):toMatchArray( { data.ten } )
end

-------------------------------------------------------------------------------
function ArrayTests.chunkSize20(data)
    expect( jo.chunk(data.ten, 20) ):toMatchArray( { data.ten } )
end


-------------------------------------------------------------------------------
ArrayTests:run()
