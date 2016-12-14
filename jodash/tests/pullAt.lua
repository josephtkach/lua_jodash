-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:PullAt" })

-------------------------------------------------------------------------------
function test.Default(data, userData)
    local input = { 'A','B','C','D','E','F','G' }
    -- incidentaly check that we can handle indices that are not present
    local toRemove = {1,3,5,7,9} 
    local removed = jo.pullAt(input, toRemove)

    expect( removed ):toMatchArray( {'A','C','E','G'} )
    expect( input ):toMatchArray( {'B','D','F'} )
end

-------------------------------------------------------------------------------
return test
