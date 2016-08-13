-------------------------------------------------------------------------------
-- difference tests
local test = junit:new({ name = "Array:Difference" })

-------------------------------------------------------------------------------
function test.TwoArrays(data)
    local actual = jo.difference({2,1}, {2,3})
    local expected = {1}
    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
function test.MultipleArrays(data)
    local actual = jo.difference({2, 1, 2, 3, 5}, {3, 4}, {3, 2})
    local expected = {1, 5} -- also implicitly tests that order is preserved
    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
function test.Objects(data)
    local object1 = {}
    local object2 = {}
    local object3 = {}

    local actual = jo.difference({object1, object2, object3}, {object1, object3})
    local expected = {object2} 

    -- not actually testing for equality, just count, technically
    -- but for our purposes it's sufficient
    expect( actual ):toMatchArray( expected )
end


-------------------------------------------------------------------------------
-- 2.0 feature: should match `NaN` ?

-------------------------------------------------------------------------------
return test
