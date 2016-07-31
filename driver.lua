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
function ArrayTests.chunk(data)
    expect( jo.chunk(data.empty) ):toBeEmpty()
end

-------------------------------------------------------------------------------
ArrayTests:run()
