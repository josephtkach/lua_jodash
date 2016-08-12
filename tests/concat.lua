-------------------------------------------------------------------------------
-- compact tests
local test = junit:new({ name = "Array:Concat" })

-------------------------------------------------------------------------------
function test.Empty(data)
    expect( jo.concat(data.empty) ):toBeEmpty()
end

-------------------------------------------------------------------------------
function test.ShallowCopy(data)
    local copy = jo.concat(data.alphabet)
    expect(copy):toMatchArray(data.alphabet)
    expect(copy):toNotBe(data.alphabet)
end

-------------------------------------------------------------------------------
function test.ArraysAndValues(data)
    local actual = jo.concat(data.allFalseys, 1, 2, data.onlyTruthy, {{data.alphabet}})
    local expected = {"", 0, false, 1, 2, "foo", 1, true, {}, {data.alphabet}}
    
    expect( actual )
        :toMatchArray( expected )
end

-------------------------------------------------------------------------------
-- maybe 2.0: treat sparse array as dense

-------------------------------------------------------------------------------
function test.WrapPrimitive(data)
    expect( jo.concat(2) ):toMatchArray( {2} )
end

-------------------------------------------------------------------------------
return test
