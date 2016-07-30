-------------------------------------------------------------------------------
-- test driver for jodash
require("string")
require("utils")

local junit = require("junit")
local jo = require("jodash")

-------------------------------------------------------------------------------
-- array tests
local ArrayTests = junit:new({ name = "Array" })

-------------------------------------------------------------------------------
function ArrayTests.chunk()

end

-------------------------------------------------------------------------------
ArrayTests:run()
