-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:Nth" })

-------------------------------------------------------------------------------
function test.Default(data)
    expect( jo.nth(data.alphabet, 3) )
        :toBe( 'C' )
end

-------------------------------------------------------------------------------
function test.NegativeIndex(data)
    expect( jo.nth(data.alphabet, -10) )
        :toBe( 'Q' )
end

-------------------------------------------------------------------------------
function test.IndexPastEnd(data)
    expect( jo.nth(data.alphabet, 40) )
        :toBe( nil )
end

-------------------------------------------------------------------------------
return test
