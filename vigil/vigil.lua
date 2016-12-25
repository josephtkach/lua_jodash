-----------------------------------------------------------------------------------------
-- vigil.lua
-- a vigil is a type of promise that you keep over and over
-----------------------------------------------------------------------------------------
local exports = {}
exports.__index = exports
local P = {} -- privates
P.debugErrors = false -- should be `false` unless we are debugging library internals

-----------------------------------------------------------------------------------------
-- debug miscellany
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
    vb(idtbl(self), " exports.reject with error", s(error).red)

    self.err = error
    P.callHandlers(self)
end

-----------------------------------------------------------------------------------------
function P.callHandlers(self)
    vb("\t", idtbl(self), "callHandlers, times: ", s(self.times).green)

    if not self.handlers then vb("\t", idtbl(self), " there are no handlers"); return end

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
    vb("\t", idtbl(self), " self.err: ", s(self.err).green)
    if self.times == 0 and not self.err then return end
    
    if self.err then
        _.safeToCall(handler.onRejected)(self.err)
    else
        _.safeToCall(handler.onFulfilled)(self.value)
    end
end

-----------------------------------------------------------------------------------------
function P.stopHandling(self, tag)
    if not self.handlers then return end

    local pull

    for k,v in ipairs(self.handlers) do
        if v.tag == tag then
            pull = k
            break
        end
    end

    if not pull then return end
    table.remove(self.handlers, pull)
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
        vb(idtbl(self), " calling invokeFn reject with reason ", s(reason).red)
        --vb(debug.traceback())
        exports.reject(self, reason)
        vb(idtbl(self), " invokeFn calling onRejected")
        vb(idtbl(self), " onRejected is ", s(onRejected).red)
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

    if self.intermediatePromise then
        P.stopHandling(self.intermediatePromise, self)
    end

    self.intermediatePromise = subsequent
    P.handle(subsequent, {
        onFulfilled = function(val)
            vb(idtbl(self), " resolving through vigil chain with ", pr(val))
            self:resolve(val)
        end,
        onRejected = function(err)
            vb(idtbl(self), " rejecting through vigil chain with ", pr(val))
            self:reject(err)
        end,
        tag = self,
    })
end

-----------------------------------------------------------------------------------------
function exports:resolve(result)
    result = result or P.trivial

    if not self then
        local newPromise = exports.new(result)
        return newPromise -- keep tail calls out of the call stack
    end

    -- clear any errors
    self.err = false

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

    if not _.isFunction(handler) then
        return false, result
    end

    vb("\thandler is a function. calling with ", pr(result))

    local succeeded, errorMsg = pcall( function()
        result = handler(result);
        vb("\thandler returned ", pr(result))
    end)

    if not succeeded then 
        vb("\trejecting with error")
        P.maybeRethrow(errorMsg)

        result = reject(errorMsg) 
    end

    return (not succeeded), result
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
                vb(idtbl(self), "onFulfilled")
                local handled, out = P.tryHandleWithResult(result, onFulfilled, resolve, reject)
                
                if not handled then
                    vb(idtbl(self), "handler did not handle")
                    out = resolve(out)
                end

                return out
            end,
            onRejected = function (result)
                vb(idtbl(self), "onRejected")

                local handled, out = P.tryHandleWithResult(result, onRejected, resolve, reject)

                if not handled then 
                    vb(idtbl(self), "handler did not handle")
                    out = reject(out)
                end

                return out
            end,
        })
    end)
    return child
end

-----------------------------------------------------------------------------------------
function P.passThrough(val)
    return val
end

-----------------------------------------------------------------------------------------
function exports:catch(fn)
    vb(idtbl(self), "catch")
    return self:andUntoThis( P.passThrough, fn ) 
end

-----------------------------------------------------------------------------------------
function exports:each(ps)
    -- todo obv
end


-----------------------------------------------------------------------------------------
return exports
