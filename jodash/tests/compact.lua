-------------------------------------------------------------------------------
-- compact tests
local test = junit:new({ name = "Array:Compact" })

-------------------------------------------------------------------------------
function test.Empty(data)
    expect( jo.compact(data.empty) ):toBeEmpty()
end

-------------------------------------------------------------------------------
function test.allFalseys(data)
    expect( jo.compact(data.allFalseys) ):toBeEmpty()
end

-------------------------------------------------------------------------------
function test.truthyAndFalsey(data)
    expect( jo.compact(data.falseyAndTruthy) ):toMatchArray( data.onlyTruthy )
end

-------------------------------------------------------------------------------
function test.onlyTruthy(data)
    expect( jo.compact(data.onlyTruthy) ):toMatchArray( data.onlyTruthy )
end

-------------------------------------------------------------------------------
return test
