-------------------------------------------------------------------------------
-- test driver for jodash
-------------------------------------------------------------------------------
junit = require("junit/index")
expect = require("junit/expect")
jo = require("jodash/index")

-------------------------------------------------------------------------------
junit.init(arg)

-------------------------------------------------------------------------------
require("tests/chunk"):run()
require("tests/compact"):run()
require("tests/concat"):run()
require("tests/difference"):run()
require("tests/differenceBy"):run()
require("tests/differenceWith"):run()
require("tests/drop"):run()
require("tests/dropRight"):run()
require("tests/dropRightWhile"):run()
require("tests/dropWhile"):run()

-------------------------------------------------------------------------------
junit.report()
