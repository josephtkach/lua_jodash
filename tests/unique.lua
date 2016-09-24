-------------------------------------------------------------------------------
local test = junit:new({ 
    name = "Array:Unique",
    userData = {
        func = jo.unique
    }
})

-------------------------------------------------------------------------------
function test.Default(data, userData)
    local actual = userData.func({1,1,2,2,3,4,5,1,6,7})
    local expected = {1,2,3,4,5,6,7}

    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
function test.Empty(data, userData)
    expect( userData.func(data.empty) ):toMatchArray( data.empty )
end

-------------------------------------------------------------------------------
function test.AlreadyClean(data, userData)
    local input = {'A', 'B', 'C'}
    local actual = userData.func(input)
    expect( actual ):toMatchArray( input )
end

-------------------------------------------------------------------------------
function test.Objects(data, userData)
    local obj1, obj2, obj3 = {}, {}, {}

    local input = {obj2, obj1, obj2, obj3}

    local actual = userData.func(input)
    local expected = {obj2, obj1, obj3} 

    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
return test
