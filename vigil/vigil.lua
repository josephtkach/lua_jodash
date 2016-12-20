-----------------------------------------------------------------------------------------
-- vigil.lua
-- a vigil is a type of promise that you keep over and over
-----------------------------------------------------------------------------------------
local exports = {}
exports.__index = exports
local P = {} -- privates
P.debugErrors = false -- should be off unless we are debugging library internals

-----------------------------------------------------------------------------------------
-- debug ish
local vb = _.noop
--local vb = print

local idtbl = idtbl or _.noop
local s = s or _.safe

local function pr(val)
    if val == nil then return s(val).red end
    if type(val) == "table" then return idtbl(val) end
    if type(val) == "string" then return val.blue end
    return s(val).yellow
end

-- todo: 
    -- make this feel lua-native
    -- modify implementation to be multiply callable

-----------------------------------------------------------------------------------------
function P.trivial(succeed)
    succeed(true)
end

-----------------------------------------------------------------------------------------
function exports.new(fn)
    fn = fn or _.noop

    local out = {
        fn = fn,
        err = false,
        times = 0, -- number of times we have processed a resolve from a child
    }

    vb("new promise ",idtbl(out))

    setmetatable(out, exports)
    P.invokeFn(out, fn, exports.resolve)

    return out
end

-----------------------------------------------------------------------------------------
function P.fulfill(self, result)
    vb(idtbl(self), " P.fulfill")

    self.value = result
    vb(idtbl(self), ".value is now ", pr(result))
    self.err = false
    P.callHandlers(self)
end

-----------------------------------------------------------------------------------------
function exports.reject(self, error)
    vb(idtbl(self), " exports.reject")

    self.err = error
    P.callHandlers(self)
end

-----------------------------------------------------------------------------------------
function P.callHandlers(self)
    vb("\t", idtbl(self), " times: ", s(self.times).green)

    if not self.handlers then vb(idtbl(self), " there are no handlers"); return end

    local action, param
    if self.err then
        param, action = self.err, "onRejected"
    else
        param, action = self.value, "onFulfilled"
    end

    vb("\t", idtbl(self), "calling all handlers with action ", action.blue,
        " and param ", pr(param)) -- that's right meatwad
   
    for k,v in ipairs(self.handlers) do
        vb("\t\t", idtbl(self), " here's one now ", s(v), s(v[action]))
        _.safe(v[action])(param)
    end
end

-----------------------------------------------------------------------------------------
function P.handle(self, handler)
    vb(idtbl(self), "handle")
    self.handlers = _.append(self.handlers, handler)
 
    vb("\t", idtbl(self), " times: ", s(self.times).green)
    if self.times == 0 then return end
    
    local func = _.ift(self.err, handler.onRejected, handler.onFulfilled)
    _.safeToCall(func)(self.value)
end

-----------------------------------------------------------------------------------------
function P.maybeRethrow(err)
    if P.debugErrors then
        print(s("rethrow").red)
        print(err)
        assert(false)
    end
end

-----------------------------------------------------------------------------------------
function P.invokeFn(self, fn, onFulfilled, onRejected)
    vb(idtbl(self), "invokeFn")

    local reject = function(reason)
        vb(idtbl(self), " calling invokeFn reject")
        exports.reject(self, reason)
        vb(idtbl(self), " invokeFn calling onRejected")
        vb(idtbl(self), " onRejected is ", s(onRejected))
        _.safe(onRejected)(self, reason) 
    end

    local succeeded, errorMsg = pcall( function()
        vb(idtbl(self), "invoking fn: ", s(fn))

        fn( function(value)
            vb( idtbl(self), "invokeFn handler, calling onFulfilled with", pr(value))
            _.safe(onFulfilled)(self, value)
        end, reject)
    end)

    if not succeeded then P.maybeRethrow(err) end
end

-----------------------------------------------------------------------------------------
function P.isVigil(x)
    return getmetatable(x) == exports
end

-----------------------------------------------------------------------------------------
function P.chainVigil(self, subsequent)
    vb(idtbl(self), " chaining into ", idtbl(subsequent))
    P.handle(subsequent, {
        onFulfilled = function(val)
            vb(idtbl(self), " resolving through vigil chain with ", pr(val))
            self:resolve(val)
        end,
        onRejected = function(err)
            vb(idtbl(self), " rejecting through vigil chain with ", pr(val))
            self:reject(err)
        end
    })
end

-----------------------------------------------------------------------------------------
function exports:resolve(result)
    result = result or P.trivial

    if not self then
        local newPromise = exports.new(result)
        return newPromise -- keep tail calls out of the call stack
    end

    vb("resolving ", idtbl(self), " with ", pr(result))--, debug.traceback())
    local succeeded, returned = pcall( function()
        -- resolve accepts either a promise or a plain value and if
        -- it's a promise, waits for it to complete
        -- going to need some kind of "once"
        if P.isVigil(result) then
            P.chainVigil(self, result)
            return
        end

        self.times = self.times + 1
        vb(idtbl(self), " incrementing times; calling P.fulfill with ", pr(result))
        P.fulfill(self, result);
    end)

    if not succeeded then
        self:reject(returned)
        P.maybeRethrow(returned)
    end

    return self
end

-----------------------------------------------------------------------------------------
function P.tryHandleWithResult(result, handler, resolve, reject)
    vb("\ttryHandleWithResult: ", pr(result))

    if _.isFunction(handler) then
        vb("\thandler is a function. calling with ", pr(result))

        local succeeded, errorMsg = pcall( function()
            result = handler(result);
            vb("\thandler returned ", pr(result))
        end)

        if not succeeded then 
            vb("\trejecting with error")
            P.maybeRethrow(errorMsg)

            local out = reject(errorMsg) 
            return out -- keep tail calls out of the call stack
        end
    end
    
    local out = resolve(result)
    return out
end

-----------------------------------------------------------------------------------------
-- this may seem like a weird name, but of course, in lua `then` is a protected keyword
-- for that reason, I decided to abandon the A+ spec in this regard. No one else is going
-- to make a library with andUntoThis, so we're just gonna go in
-----------------------------------------------------------------------------------------
function exports:andUntoThis(onFulfilled, onRejected)
    vb(idtbl(self), " and unto this")
    local child = exports.new( function(resolve, reject)
        P.handle(self, {
            onFulfilled = function (result)
                local out = P.tryHandleWithResult(result, onFulfilled, resolve, reject)
                return out
            end,
            onRejected = function (result)
                local out = P.tryHandleWithResult(result, onRejected, resolve, reject)
                return out
            end,
        })
    end)
    return child
end

-----------------------------------------------------------------------------------------
function exports:each(ps)
    -- todo obv
end

-----------------------------------------------------------------------------------------
function exports:catch(fn)
    -- todo obv
end

-----------------------------------------------------------------------------------------
return exports
