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

    vigil.resolve()
    :andUntoThis( function()
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
    local value = false

    local p = vigil.new( function(resolve, reject)
        _resolve = resolve
        _reject = reject
    end)
    :andUntoThis( function(got)
        value = got
    end)

    _resolve("resolved")

    expect(value):toBe("resolved")
end

-------------------------------------------------------------------------------
function test.returnAPromise()
    local innerPromise
    local thenFinished = false

    vigil.resolve()
    :andUntoThis( function()
        innerPromise = vigil.new( function() end )
        return innerPromise
    end)
    :andUntoThis( function(value)
        thenFinished = value
    end)

    expect(thenFinished):toBe(false)
    innerPromise:resolve("resolved")
    expect(thenFinished):toBe("resolved")
end

-------------------------------------------------------------------------------
function test.resolveAgain()
    local executed = 0

    local start = vigil.new()

    start:andUntoThis( function()
        executed = executed + 1
    end)

    expect(executed):toBe(0)
    start:resolve()
    expect(executed):toBe(1)
    start:resolve()
    expect(executed):toBe(2)
end

-------------------------------------------------------------------------------
function test.resolve_addThen_resolve()
    local executedFirst = 0
    local executedSecond = 0

    local start = vigil.new()

    expect(executedFirst):toBe(0)
    expect(executedSecond):toBe(0)
    expect(start.times):toBe(0)
    
    start:resolve()
    
    expect(start.times):toBe(1)
    
    start:andUntoThis( function()
        executedFirst = executedFirst + 1
    end)
    :andUntoThis( function()
        executedSecond = executedSecond + 1
    end)

    expect(executedFirst):toBe(1)
    expect(executedSecond):toBe(1)
    expect(start.times):toBe(1)

    start:resolve()
    expect(executedFirst):toBe(2)
    expect(executedSecond):toBe(2)
    expect(start.times):toBe(2)
end

-------------------------------------------------------------------------------
function test.catch()
    local gotToSuccess = false
    local didCatch = false

    vigil.resolve()
    :andUntoThis( function()
        assert(false)
    end)
    :andUntoThis( function()
        gotToSuccess = true
    end)
    :catch( function(err)
        didCatch = true
    end)

    expect(gotToSuccess):toBe(false)
    expect(didCatch):toBe(true)
end

-------------------------------------------------------------------------------
function test.catchPassThrough()
    local gotToSuccess = false
    local didCatch = false

    vigil.resolve()
    :catch( function(err)
        didCatch = true
    end)
    :andUntoThis( function()
        gotToSuccess = true
    end)
    

    expect(gotToSuccess):toBe(true)
    expect(didCatch):toBe(false)
end

-------------------------------------------------------------------------------
function test.returnAPromiseAgain()
    local innerPromises = {}
    local executedFinal = 1

    local start = vigil.resolve()

    start:andUntoThis( function()
        innerPromises[executedFinal] = vigil.new( function() end )
        return innerPromises[executedFinal]
    end)
    :andUntoThis( function(value)
         executedFinal = executedFinal + 1
    end)

    expect(executedFinal):toBe(1)
    
    innerPromises[1]:resolve("resolved")
    expect(executedFinal):toBe(2)

    start:resolve()
    expect(innerPromises[2]):toExist()

    innerPromises[1]:resolve("resolved")
    expect(executedFinal):toBe(2)

    innerPromises[2]:resolve("resolved")
    expect(executedFinal):toBe(3)
end

-------------------------------------------------------------------------------
return test
