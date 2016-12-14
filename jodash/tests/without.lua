-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:Without" })

-------------------------------------------------------------------------------
function test.TwoArrays(data, userData)
    local actual = jo.without({2,1}, {2,3})
    local expected = {1}

    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
function test.Objects(data, userData)
    local object1 = {}
    local object2 = {}
    local object3 = {}

    local actual = jo.without({object1, object2, object3}, {object1, object3})
    local expected = {object2} 

    -- not actually testing for equality, just count, technically
    -- but for our purposes it's sufficient
    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
return test
