-------------------------------------------------------------------------------
-- chunk tests
local test = junit:new({ name = "Array:DropRightWhile" })


local users = {
  { user = "barney",  active = true  },
  { user = "fred",    active = false },
  { user = "pebbles", active = false },
}
--[[

// The `_.matches` iteratee shorthand.
_.dropRightWhile(users, { 'user': 'pebbles', 'active': false });
// ➜ objects for ['barney', 'fred']

// The `_.matchesProperty` iteratee shorthand.
_.dropRightWhile(users, ['active', false]);
// ➜ objects for ['barney']

// The `_.property` iteratee shorthand.
_.dropRightWhile(users, 'active');
// ➜ objects for ['barney', 'fred', 'pebbles']
--]]

-------------------------------------------------------------------------------
function test.Default(data)
    expect( jo.dropRightWhile(users, function(o) return not o.active end) )
        :toMatchArray({
            { user = "barney", active = true} 
        })
end

-------------------------------------------------------------------------------
function test.Matches(data)
    expect( jo.dropRightWhile(users, {user="pebbles", active=false}) )
        :toMatchArray({ 
            { user = "barney", active = true},
            { user = "fred", active = false},
        })
end

-------------------------------------------------------------------------------
function test.MatchesProperty(data)
    expect( jo.dropRightWhile(users, {"active", false}) )
        :toMatchArray({ 
            { user = "barney", active = true},
        })
end

-------------------------------------------------------------------------------
function test.Property(data)
    expect( jo.dropRightWhile(users, "active") ):toMatchArray( users )
end

-------------------------------------------------------------------------------
return test
