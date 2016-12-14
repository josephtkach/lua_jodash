-------------------------------------------------------------------------------
local test = junit:new({ 
    name = "Array:Intersection",
    userData = {
        func = jo.intersection
    }
})

-------------------------------------------------------------------------------
function test.TwoArrays(data, userData)
    local actual = userData.func({2,1}, {2,3})
    local expected = {2}

    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
function test.MultipleArrays(data, userData)
    local actual = userData.func({2, 1, 4, 3, 5, 7}, {7, 3, 4}, {3, 7, 2})
    local expected = {3, 7} -- also implicitly tests that order is preserved
    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
function test.Objects(data, userData)
    local object1 = {}
    local object2 = {}
    local object3 = {}

    local actual = userData.func({object1, object2, object3}, {object1, object3})
    local expected = { object1, object3 } 

    -- not actually testing for equality, just count, technically
    -- but for our purposes it's sufficient
    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
-- 2.0 feature: should match `NaN` ?

-------------------------------------------------------------------------------
return test
