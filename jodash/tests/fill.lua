-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:Fill" })

-- _.fill(Array(3), 2);
-- [2, 2, 2]

-- _.fill([4, 6, 8, 10], '*', 1, 3);
-- [4, '*', '*', 10]

-------------------------------------------------------------------------------
function test.Default(data)
    local users = {
      { user = "barney",  active = true  },
      { user = "fred",    active = false },
      { user = "pebbles", active = false },
    }
    expect( jo.fill({1, 2, 3}, 'a') )
        :toMatchArray( {'a', 'a', 'a'}  )
end

-------------------------------------------------------------------------------
function test.Allocate(data)
    expect( jo.fill(3, 'a') )
        :toMatchArray( {'a', 'a', 'a'} )
end

-------------------------------------------------------------------------------
function test.NegativeStart(data)
     expect( jo.fill({1,2,3}, 'a', -1) )
        :toMatchArray( {'a', 'a', 'a'} )
end

-------------------------------------------------------------------------------
function test.NegativeEnd(data)
    expect( jo.fill(data.ten, 'a', 0, -1) )
        :toMatchArray( data.ten )
end

-------------------------------------------------------------------------------
function test.StartGTEnd(data)
    expect( jo.fill(data.ten, 'a', 5, 4) )
        :toMatchArray( data.ten )
end

-------------------------------------------------------------------------------
function test.StartPastTheEnd(data)
  local actual = jo.fill({1,2,3}, 'a', math.huge, 4)
  local expected = {1,2,3}

  expect( actual )
        :toMatchArray( expected )
end

-------------------------------------------------------------------------------
function test.EndPastTheEnd(data)
    expect( jo.fill({1, 2, 3}, 'a',1, math.huge) )
        :toMatchArray( {'a', 'a', 'a'}  )
end

-------------------------------------------------------------------------------
function test.FloatingPointBounds(data)
    expect( jo.fill({1, 2, 3}, 'b', 1.1, 2.2) )
        :toMatchArray( {'b', 'b', 3} )
end

-------------------------------------------------------------------------------
return test
