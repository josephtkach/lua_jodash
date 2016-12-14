-------------------------------------------------------------------------------
local test = junit:new({ name = "andUntoThis" })

-------------------------------------------------------------------------------
function test.trivial()
    local executed = 0
    
    vigil.resolve():andUntoThis( function()
        executed = executed + 1
    end, vigil.rethrow)

    expect(executed):toBe(1)
end

-------------------------------------------------------------------------------
return test
