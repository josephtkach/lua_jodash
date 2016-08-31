-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:lastIndexOf" })

-------------------------------------------------------------------------------
function test.Default(data)
    expect( jo.lastIndexOf(data.alphabet, 'C') )
        :toBe( 3 )
end

-------------------------------------------------------------------------------
function test.IndexPastEnd(data)
    expect( jo.lastIndexOf(data.alphabet, 'C', 40) )
        :toBe( 3 )
end

-------------------------------------------------------------------------------
function test.TreatFalseyFromIndexAsZero(data)
    for i,v in ipairs(data.allFalseys) do
        expect( jo.lastIndexOf(data.alphabet, 'C', v) )
            :toBe( 3 )
    end
end

-------------------------------------------------------------------------------
function test.CoerceFromIndexToInteger(data)
    expect( jo.lastIndexOf(data.alphabet, 'E', 7.5) )
        :toBe( 5 )
end

-------------------------------------------------------------------------------
return test
