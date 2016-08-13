-------------------------------------------------------------------------------
-- test driver for jodash
-------------------------------------------------------------------------------
junit = require("junit/index")
expect = require("junit/expect")
jo = require("jodash/index")

-------------------------------------------------------------------------------
--require("tests/chunk"):run()
--require("tests/compact"):run()
--require("tests/concat"):run()
require("tests/difference"):run()
require("tests/differenceBy"):run()
