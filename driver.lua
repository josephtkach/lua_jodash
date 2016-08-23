-------------------------------------------------------------------------------
-- test driver for jodash
-------------------------------------------------------------------------------
junit = require("junit/index")
expect = require("junit/expect")
jo = require("jodash/index")

-------------------------------------------------------------------------------
junit.init(arg)

-------------------------------------------------------------------------------
function eaprint(actual, expected)
    print("actual")
    tprint(actual)    
    print("expected")
    tprint(expected)
end

-------------------------------------------------------------------------------
--[[ require("tests/chunk"):run()
require("tests/compact"):run()
require("tests/concat"):run()
require("tests/difference"):run()
require("tests/differenceBy"):run()
require("tests/differenceWith"):run()
require("tests/drop"):run()
require("tests/dropRight"):run()
require("tests/dropRightWhile"):run()
require("tests/dropWhile"):run()
require("tests/fill"):run() 
require("tests/findIndex"):run() --]]
require("tests/findLastIndex"):run()

-------------------------------------------------------------------------------
junit.report()
