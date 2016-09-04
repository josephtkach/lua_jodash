-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:Reverse" })

-------------------------------------------------------------------------------
function test.Even(data, userData)
    local input = deepCopy(data.ten)
    expect( jo.reverse(input) ):toBe( input )
    expect( input ):toMatchArray( {10,9,8,7,6,5,4,3,2,1} )
end

-------------------------------------------------------------------------------
function test.Odd(data)
    local input = {"A", "B", "C", "D", "E"}
    expect( jo.reverse(input) ):toBe( input )
    expect( input ):toMatchArray( { "E", "D", "C", "B", "A"} )
end

-------------------------------------------------------------------------------
function test.Empty(data)
    local input = {}
      
    expect( jo.reverse(input) ):toBe( input )
    expect( input ):toMatchArray( {} )
end

-------------------------------------------------------------------------------
return test
