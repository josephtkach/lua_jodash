-------------------------------------------------------------------------------
local test = junit:new({ name = "resolve" })

-------------------------------------------------------------------------------
function test.startChain()
    vigil.resolve()
end

-------------------------------------------------------------------------------
function test.trivial()
    local _resolve, _reject

    local p = vigil.new( function(resolve, reject)
        _resolve = resolve
        _reject = reject
    end)

    -- we're going to cheat and peak at the internal state of P
    expect(p.inputs):toBe(0)
    expect(p.outputs):toBe(0)
    expect(p.err):toBe(false)

    _resolve("resolved")

    expect(p.inputs):toBe(1)
    expect(p.outputs):toBe(1)
    expect(p.err):toBe(false)
    expect(p.value):toBe("resolved")
end

-------------------------------------------------------------------------------
return test
