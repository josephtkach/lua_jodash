-------------------------------------------------------------------------------
local test = junit:new({ 
    name = "Array:Xor",
    userData = {
        func = jo.xor
    }
})

-------------------------------------------------------------------------------
function test.TwoArrays(data, userData)
    local actual = userData.func({2,1}, {2,3})
    local expected = {1,3}

    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
function test.MultipleArrays(data, userData)
    local actual = userData.func({2, 1, 2, 3, 5}, {3, 4}, {7, 3, 2})
    local expected = {1, 5, 4, 7} -- that's numberwang
    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
function test.Objects(data, userData)
    local object1 = {}
    local object2 = {}
    local object3 = {}

    local input = {object1, object2, object3}
    local actual = userData.func(input, {object1, object3})
    local expected = { object2 }
    -- not actually testing for equality, just count, technically
    -- but for our purposes it's sufficient
    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
return test
