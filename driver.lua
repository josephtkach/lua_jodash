-------------------------------------------------------------------------------
-- test driver for jodash
-------------------------------------------------------------------------------
junit = require("junit/index")
expect = require("junit/expect")
jo = require("jodash/index")

-------------------------------------------------------------------------------
junit.init(arg)

-------------------------------------------------------------------------------
-- array tests
-------------------------------------------------------------------------------
junit.testModule({
    name = "array",
    object = require("jodash/array"),
})
