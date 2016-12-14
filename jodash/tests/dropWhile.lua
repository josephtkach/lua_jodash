-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:DropWhile" })

local users = {
  { user = "barney",  active = false  },
  { user = "barney",  active = false  },
  { user = "fred",    active = false },
  { user = "pebbles", active = true },
}

-------------------------------------------------------------------------------
function test.Default(data)
    local actual = jo.dropWhile(users, function(o) return not o.active end)
    local expected = {
        {user = "pebbles", active = true} 
    }

    expect( actual ):toMatchArray( expected )
end

-------------------------------------------------------------------------------
function test.Matches(data)
    expect( jo.dropWhile(users, {user="barney", active=false}) )
        :toMatchArray({ 
            {user = "fred", active = false},
            {user = "pebbles", active = true},
        })
end

-------------------------------------------------------------------------------
function test.MatchesProperty(data)
    expect( jo.dropWhile(users, {"active", false}) )
        :toMatchArray({ 
            {user = "pebbles", active = true},
        })
end

-------------------------------------------------------------------------------
function test.Property(data)
    expect( jo.dropWhile(users, "active") ):toMatchArray( users )
end

-------------------------------------------------------------------------------
return test
