-------------------------------------------------------------------------------
local test = junit:new({ 
    name = "Array:PullAll",
    userData = {
        func = jo.pullAll
    }
})

-------------------------------------------------------------------------------
function test.Default(data, userData)
    local tenCopy = deepCopy(data.ten)
    local actual = userData.func(tenCopy, {1})

    expect( actual ):toBe( tenCopy )
    expect( actual ):toMatchArray( {2,3,4,5,6,7,8,9,10} )
end

-------------------------------------------------------------------------------
function test.MultipleValues(data, userData)
    local tenCopy = deepCopy(data.ten)
    local actual = userData.func(tenCopy, {1,4,5,6,10})

    expect( actual ):toBe( tenCopy )
    expect( actual ):toMatchArray( {2,3,7,8,9} )
end

-------------------------------------------------------------------------------
function test.Objects(data, userData)
    local object1 = {}
    local object2 = {}
    local object3 = {}

    local input = {object1, object2, object3}

    local actual = userData.func(input, {object1})
    local expected = {object2, object3} 

    -- not actually testing for equality, just count, technically
    -- but for our purposes it's sufficient
    expect( actual ):toBe( input )
    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
-- 2.0 feature: should match `NaN` ?

-------------------------------------------------------------------------------
return test
