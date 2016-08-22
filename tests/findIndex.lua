-------------------------------------------------------------------------------
-- chunk tests
local test = junit:new({ name = "Array:FindIndex" })

-------------------------------------------------------------------------------
local users = {
    { user = "barney",  active = false },
    { user = "fred",    active = false, extra = "dat boi" },
    { user = "pebbles", active = true }
}

-------------------------------------------------------------------------------
local function finder(name)
    return function(o) return o.user == name end
end

-------------------------------------------------------------------------------
function test.Default(data)
    expect( jo.findIndex(users, finder("barney")) )
        :toBe( 1 )
end

-------------------------------------------------------------------------------
function test.HandleNegativeFromIndex(data)
    expect( jo.findIndex(users, finder("barney"), -1) )
        :toBe( -1 )
end

-------------------------------------------------------------------------------
function test.TreatFalseyFromIndexAsZero(data)
    for i,v in ipairs(data.allFalseys) do
        expect( jo.findIndex(users, finder("barney"), v) )
            :toBe( 1 )
    end
end

-------------------------------------------------------------------------------
function test.CoerceFromIndexToInteger(data)
    expect( jo.findIndex(users, finder("pebbles"), 1.4) )
        :toBe( 3 )
end

-------------------------------------------------------------------------------
function test.MatchesShorthand(data)
    expect( jo.findIndex(users, {user="pebbles",active=true}) )
        :toBe( 3 )
end

-------------------------------------------------------------------------------
function test.MatchesPropertyShorthand(data)
    expect( jo.findIndex(users, {"active",true}) )
        :toBe( 3 )
end

-------------------------------------------------------------------------------
function test.PropertyShorthand(data)
    expect( jo.findIndex(users, "extra") )
        :toBe( 2 )
end
-------------------------------------------------------------------------------
return test
