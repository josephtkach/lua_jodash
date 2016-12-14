-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:TakeRightWhile" })

local users = {
  { user = "barney",  active = true  },
  { user = "fred",    active = false },
  { user = "pebbles", active = false },
}

-------------------------------------------------------------------------------
local theRightAnswer = {
    { user = "fred",    active = false },
    { user = "pebbles", active = false },
}

-------------------------------------------------------------------------------
function test.Default(data)
    expect( jo.takeRightWhile(users, function(o) return not o.active end) )
        :toMatchArray( theRightAnswer )
end

-------------------------------------------------------------------------------
function test.Matches(data)
    expect( jo.takeRightWhile(users, {active=false}) )
        :toMatchArray( theRightAnswer )
end

-------------------------------------------------------------------------------
function test.MatchesProperty(data)
    expect( jo.takeRightWhile(users, {"active", false}) )
        :toMatchArray( theRightAnswer )
end

-------------------------------------------------------------------------------
function test.Property(data)
    expect( jo.takeRightWhile(users, "active") )
        :toMatchArray( data.empty )
end

-------------------------------------------------------------------------------
return test
