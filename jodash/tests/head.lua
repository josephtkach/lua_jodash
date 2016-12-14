-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:Head/First" })

-------------------------------------------------------------------------------
function test.Default(data)
    expect( jo.head( data.alphabet ) )
        :toBe( 'A' )
end

-------------------------------------------------------------------------------
function test.First(data)
    expect( jo.first( data.alphabet ) )
        :toBe( 'A' )
end

-------------------------------------------------------------------------------
function test.Empty(data)
    expect( jo.head( data.empty ) )
        :toBe( nil )
end

-------------------------------------------------------------------------------
function test.NonTable(data)
    expect( jo.head( nil ) )
        :toBe( nil )
end


-------------------------------------------------------------------------------
return test
