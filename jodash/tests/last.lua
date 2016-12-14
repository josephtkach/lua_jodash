-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:Last" })

-------------------------------------------------------------------------------
function test.Default(data)
    expect( jo.last( data.alphabet ) )
        :toBe( 'Z' )
end

-------------------------------------------------------------------------------
function test.Empty(data)
    expect( jo.last( data.empty ) )
        :toBe( nil )
end

-------------------------------------------------------------------------------
function test.NonTable(data)
    expect( jo.last( nil ) )
        :toBe( nil )
end


-------------------------------------------------------------------------------
return test
