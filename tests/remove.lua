-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:Remove" })

-------------------------------------------------------------------------------
local users = {
    { user = "barney",  active = false },
    { user = "fred",    active = false, extra = "dat boi" },
    { user = "pebbles", active = true },
}

-------------------------------------------------------------------------------
function test.Default(data, userData)
    local input = deepCopy(users)
    local removed = jo.remove(input, function(x) return x.user == "barney" end)

    expect( removed ):toMatchArray( { { user = "barney",  active = false }, } )
    expect( input ):toMatchArray( {
        { user = "fred",    active = false, extra = "dat boi" },
        { user = "pebbles", active = true },
    } )
end

-------------------------------------------------------------------------------
function test.MatchesShorthand(data)
    local input = deepCopy(users)
    local removed = jo.remove(input, {user="barney"} )
      
    expect( removed ):toMatchArray( { { user = "barney",  active = false }, } )
    expect( input ):toMatchArray( {
        { user = "fred",    active = false, extra = "dat boi" },
        { user = "pebbles", active = true },
    } )
end

--[[
-------------------------------------------------------------------------------
function test.MatchesPropertyShorthand(data)
    expect( jo.findIndex(users, {"active",true}) )
        :toBe( 3 )
end

-------------------------------------------------------------------------------
function test.PropertyShorthand(data)
    expect( jo.findIndex(users, "extra") )
        :toBe( 2 )
end--]]

-------------------------------------------------------------------------------
return test
