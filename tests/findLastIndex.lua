-------------------------------------------------------------------------------
-- chunk tests
local test = junit:new({ name = "Array:FindLastIndex" })

-------------------------------------------------------------------------------
local users = {
    { user = "barney",  active = false },
    { user = "fred",    active = false, extra = "dat boi" },
    { user = "pebbles", active = true },
    { user = "barney", active = false },
    { user = "pebbles", active = true },
}

-------------------------------------------------------------------------------
local function finder(name)
    return function(o) return o.user == name end
end

-------------------------------------------------------------------------------
function test.Default(data)
    expect( jo.findLastIndex(users, finder("barney")) )
        :toBe( 4 )
end

-------------------------------------------------------------------------------
function test.HandleFromIndexGTLength(data)
    expect( jo.findLastIndex(users, finder("barney"), 10) )
        :toBe( 4 )
end

-------------------------------------------------------------------------------
function test.TreatFalseyFromIndexAsLength(data)
    for i,v in ipairs(data.allFalseys) do
        expect( jo.findLastIndex(users, finder("barney"), v) )
            :toBe( 4 )
    end
end

-------------------------------------------------------------------------------
function test.CoerceFromIndexToInteger(data)
    expect( jo.findLastIndex(users, finder("pebbles"), 3.5) )
        :toBe( 3 )
end

-------------------------------------------------------------------------------
function test.MatchesShorthand(data)
    expect( jo.findLastIndex(users, {user="pebbles",active=true}) )
        :toBe( 5 )
end

-------------------------------------------------------------------------------
function test.MatchesPropertyShorthand(data)
    expect( jo.findLastIndex(users, {"active",true}) )
        :toBe( 5 )
end

-------------------------------------------------------------------------------
function test.PropertyShorthand(data)
    expect( jo.findLastIndex(users, "extra") )
        :toBe( 2 )
end

-------------------------------------------------------------------------------
return test
