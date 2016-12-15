-------------------------------------------------------------------------------
local test = junit:new({ name = "andUntoThis" })

-------------------------------------------------------------------------------
function test.trivial()
    local count = 0
    
    vigil.resolve():andUntoThis( function()
        count = count + 1
    end)

    expect(count):toBe(1)
end

-------------------------------------------------------------------------------
function test.inOrder()
    local first, second, third = false, false, false
    local count = 0

    vigil.resolve():andUntoThis( function()
        first = true
        expect(second):toBe(false)
        expect(third):toBe(false)

        count = count + 1
    end)
    :andUntoThis( function()
        expect(first):toBe(true)
        second = true
        expect(third):toBe(false)
     
        count = count + 1
    end)
     :andUntoThis( function()
        expect(first):toBe(true)
        expect(second):toBe(true)
        third = true

        count = count + 1
    end)

    expect(count):toBe(3)
end

-------------------------------------------------------------------------------
function test.outOfOrder()
    local _resolve, _reject
    local thenFinished = false

    local p = vigil.new( function(resolve, reject)
        _resolve = resolve
        _reject = reject
    end)
    :andUntoThis( function()
        thenFinished = true
    end)

    _resolve("resolved")
    
    expect(thenFinished):toBe(true)
end

-------------------------------------------------------------------------------
function test.failStopsPropagation()
    local gotToSuccess = false

    vigil.resolve():andUntoThis( function()
        assert(false)
    end)
    :andUntoThis( function()
        gotToSuccess = true
    end)

    expect(gotToSuccess):toBe(false)
end

-------------------------------------------------------------------------------
return test
