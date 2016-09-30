local test = deepCopy( require("tests/unzipWith") )
test.name = "Array:ZipWith"
test.userData = { func = jo.zipWith }
return test
