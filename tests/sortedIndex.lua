-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
local test = junit:new({ 
    name = "Array:SortedIndex",
    userData = {
        func = jo.sortedIndex
    }
})

-------------------------------------------------------------------------------
function test.Default(data, userData)
    expect( userData.func({1,2,4,5}, 3) ):toBe( 3 )
end

-------------------------------------------------------------------------------
function test.TinyArray(data, userData)
    expect( userData.func({30,50}, 40) ):toBe( 2 )
end

-------------------------------------------------------------------------------
function test.ValueAlreadyPresent(data, userData)
    expect( userData.func(data.ten, 7) ):toBe( 7 )
end

-------------------------------------------------------------------------------
function test.ShouldGoAfter(data, userData)
    expect( userData.func(data.ten, 11) ):toBe( 11 )
end

-------------------------------------------------------------------------------
function test.ShouldGoBefore(data, userData)
    expect( userData.func(data.ten, -1) ):toBe( 0 )
end

-------------------------------------------------------------------------------
return test
