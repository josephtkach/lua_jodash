-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:indexOf" })

-------------------------------------------------------------------------------
function test.Default(data)
    expect( jo.indexOf(data.alphabet, 'C') )
        :toBe( 3 )
end

-------------------------------------------------------------------------------
function test.HandleNegativeFromIndex(data)
    expect( jo.indexOf(data.alphabet, 'C', -4) )
        :toBe( -1 )
end

-------------------------------------------------------------------------------
function test.TreatFalseyFromIndexAsZero(data)
    for i,v in ipairs(data.allFalseys) do
        expect( jo.indexOf(data.alphabet, 'C', v) )
            :toBe( 3 )
    end
end

-------------------------------------------------------------------------------
function test.CoerceFromIndexToInteger(data)
    expect( jo.indexOf(data.alphabet, 'E', 3.5) )
        :toBe( 5 )
end

-------------------------------------------------------------------------------
return test
