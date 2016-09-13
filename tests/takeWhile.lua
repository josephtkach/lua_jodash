-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:TakeWhile" })

local users = {
  { user = "barney",  active = true  },
  { user = "fred",    active = true },
  { user = "betty", active = false },
  { user = "wilma", active = false },
  { user = "pebbles", active = false },
}

-------------------------------------------------------------------------------
local theRightAnswer = {
  { user = "barney",  active = true  },
  { user = "fred",    active = true },
}

-------------------------------------------------------------------------------
function test.Default(data)
    expect( jo.takeWhile(users, function(o) return o.active end) )
        :toMatchArray( theRightAnswer )
end

-------------------------------------------------------------------------------
function test.Matches(data)
    expect( jo.takeWhile(users, {active=true}) )
        :toMatchArray( theRightAnswer )
end

-------------------------------------------------------------------------------
function test.MatchesProperty(data)
    expect( jo.takeWhile(users, {"active", true}) )
        :toMatchArray( theRightAnswer )
end

-------------------------------------------------------------------------------
function test.Property(data)
    expect( jo.takeWhile(users, "active") )
        :toMatchArray( theRightAnswer )
end

-------------------------------------------------------------------------------
return test
