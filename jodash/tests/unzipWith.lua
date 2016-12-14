-------------------------------------------------------------------------------
local test = deepCopy( require("tests/unzip") )
test.name = "Array:UnzipWith"
test.userData = { func = jo.unzipWith }

-------------------------------------------------------------------------------
function test.Iteratee(data, userData)
    local input = { {1, 2}, {10, 20}, {100, 200} }
    local zipped = jo.zip(input)

    expect( userData.func(zipped, jo.add) )
        :toMatchArray( {3,30,300} )
end

-------------------------------------------------------------------------------
return test
