local test = deepCopy( require("tests/unzip") )
test.name = "Array:Zip"
test.userData = { func = jo.zip }
return test
