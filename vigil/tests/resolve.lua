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
function test.withAPromise()
    local _resolve, _reject
    local finished = false

    local p = vigil.new( function(resolve, reject)
        _resolve = resolve
        _reject = reject
    end)

    p:andUntoThis( function(val)
        finished = val
    end)

    local _resolve2, _reject2
    local p2 = vigil.new( function(resolve, reject)
        _resolve2 = resolve
        _reject2 = reject
    end)

    _resolve(p2)

    expect(p.inputs):toBe(1)
    expect(p.outputs):toBe(0)
    expect(p.err):toBe(false)
    expect(p.value):toBe(nil)

    expect(finished):toBe(false)

    _resolve2("resolved")

    expect(p.inputs):toBe(1)
    expect(p.outputs):toBe(1)
    expect(p.err):toBe(false)

    expect(p.value):toBe("resolved")
    expect(finished):toBe("resolved")
end

-------------------------------------------------------------------------------
return test
