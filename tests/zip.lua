-------------------------------------------------------------------------------
local test = junit:new({ 
    name = "Array:Zip",
    userData = {
        func = jo.zip
    }
})

-------------------------------------------------------------------------------
-- _.zip(['a', 'b'], [1, 2], [true, false]);
-- => [['a', 1, true], ['b', 2, false]] 
function test.Default(data, userData)
    local input = { {'a','b'}, {1,2}, {true,false} }

    expect( userData.func(input) )
        :toMatchArray( {{'a', 1, true}, {'b', 2, false}} )
end

-------------------------------------------------------------------------------
function test.Empty(data, userData)
    expect( data.empty ):toMatchArray( data.empty )
end

-------------------------------------------------------------------------------
function test.oneByOne(data, userData)
    local input = { {'a'}, }

    expect( userData.func(input) )
        :toMatchArray( {{'a'}} )
end

-------------------------------------------------------------------------------
function test.Uneven(data, userData)
    local input = { {'a','b'}, {1}, {true,false} }

    expect( userData.func(input) )
        :toMatchArray( {{'a', 1, true}, {'b', jo.UNDEFINED(), false}} )
end

-------------------------------------------------------------------------------
function test.Bigger(data, userData)
    local input = { {'a','b','c'}, {1,2,3}, {true,false,true}, {'j','o','e' } }

    expect( userData.func(input) )
        :toMatchArray( {
            {'a', 1, true, 'j'},
            {'b', 2, false, 'o'},
            {'c', 3, true, 'e'} 
        } )
end

-------------------------------------------------------------------------------
return test
