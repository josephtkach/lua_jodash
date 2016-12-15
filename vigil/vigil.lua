-----------------------------------------------------------------------------------------
-- vigil.lua
-- a vigil is a type of promise that you keep over and over
-----------------------------------------------------------------------------------------
local exports = {}
exports.__index = exports

--local vb = _.noop
local vb = print

local P = {} -- privates
-- todo: 
    -- make it work
    -- make this feel lua-native
    -- modify implementation to be multiply callable
    -- better error handling

-----------------------------------------------------------------------------------------
function P.trivial(succeed)
    succeed(true)
end

-----------------------------------------------------------------------------------------
function exports.new(fn)
    local out = {
        fn = fn,
        err = false,
        inputs = 0, -- number of times we have processed a resolve from a parent
        outputs = 0, -- number of times we have processed a resolve from a child
    }

    vb("new promise ",idtbl(out))

    setmetatable(out, exports)
    P.doResolve(out, fn, exports.resolve, exports.reject)

    return out
end

-----------------------------------------------------------------------------------------
function P.fulfill(self, result)
    self.value = result;
    self.err = false
    P.callHandlers(self)
end

-----------------------------------------------------------------------------------------
function exports.reject(self, error)
    self.err = error
    P.callHandlers(self)
    if not self.handlers then P.rethrow(error) end
end

-----------------------------------------------------------------------------------------
function P.callHandlers(self)
    vb("\t", idtbl(self), " number of outputs: ", s(self.outputs).green)

    if not self.handlers then vb(idtbl(self), " there are no handlers"); return end
    local action = _.ift(self.err, "onRejected", "onFulfilled")
    vb("calling all handlers with action ", action) -- that's right meatwad
    for k,v in ipairs(self.handlers) do
        _.safe(v[action])
    end
end

-----------------------------------------------------------------------------------------
function P.handle(self, handler)
    vb(idtbl(self), "handle")
    self.handlers = _.append(self.handlers, handler)
 
    vb("\t", idtbl(self), " number of outputs: ", s(self.outputs).green)
    if self.outputs == 0 then return end
    
    local func = _.ift(self.err, handler.onRejected, handler.onFulfilled)
    _.safeToCall(func)(self.value)
end

-----------------------------------------------------------------------------------------
function P.rethrow(err)
    assert(false, err)
end

-----------------------------------------------------------------------------------------
function P.doResolve(self, fn, onFulfilled, onRejected)
    vb(idtbl(self), "doResolve")
    local done = false

    local reject = function(reason)
        vb(idtbl(self), " calling doResolve reject")
        vb(idtbl(self), " done is ", tostring(done))
        if done then vb("returned early"); return end
        done = true
        exports.reject(self, reason)
        vb(idtbl(self), " doResolve calling onRejected")
        print(idtbl(self), " onRejected is ", s(onRejected))
        _.safe(onRejected)(self, reason) 
    end

    local status, err = pcall( function()
        vb(idtbl(self), "invoking fn: ", tostring(fn))

        fn( function(value)
            self.inputs = self.inputs + 1
            vb(idtbl(self), "fn completed")

            if done then vb(idtbl(self), " was already done"); return end
            done = true
            vb(idtbl(self), " onFulfilled from doResolve ", tostring(onFulfilled));
            _.safe(onFulfilled)(self, value)
        end, reject)
    end)

    if err then
        reject(err)
    end
end

-----------------------------------------------------------------------------------------
function P.done(self, onFulfilled, onRejected)
    vb(idtbl(self), "done")
    P.handle(self, {
        onFulfilled = onFulfilled,
        onRejected = onRejected or P.rethrow
    })
end

-----------------------------------------------------------------------------------------
function P.getUntoThis(value)
    if _.isTable(value) then
        return value.andUntoThis
    end
end

-----------------------------------------------------------------------------------------
function exports.isVigil(x)
    return getmetatable(x) == exports
end

-----------------------------------------------------------------------------------------
function exports:resolve(result)
    result = result or P.trivial

    if not self then
        local newPromise = exports.new(result)
        return newPromise -- avoid tail calls, they shred callstacks
    end

    vb("resolving ", idtbl(self))--, debug.traceback())
    local status, err = pcall( function()
        self.outputs = self.outputs + 1

        local andUntoThis = P.getUntoThis(result)
        if andUntoThis then
            --P.doResolve(self, function()
                -- todo
            --end)

            -- the bind() method creates a new function that, 
            -- when called, has its this keyword set to the 
            -- provided value, with a given sequence of arguments 
            -- preceding any provided when the new function is called.
            --P.doResolve(andUntoThis.bind(result), resolve, reject)
            return
        end

        P.fulfill(self, result);
    end)

    if err then
        self:reject(err)
    end

    return self
end

-----------------------------------------------------------------------------------------
function exports:andUntoThis(onFulfilled, onRejected)
    vb(idtbl(self), " and unto this")
    local child = exports.new( function(resolve, reject)
        P.done(self, function (result)
            vb("\tandUntoThis done, result is: ", tostring(result))
            local out

            if _.isFunction(onFulfilled) then
                vb("\tonFulfilled is a function")
                local status, err = pcall( function()
                    vb("\tcalling resolve with onFulfilled(result))")
                    out = resolve(onFulfilled(result));
                end)

                if err then vb("\trejecting with err"); out = reject(err) end
            else
                vb("\tonFulfilled is no function. result:", tostring(result));
                out = resolve(result);
            end
            return out
        end,
        function (error)
            vb("there's an error")
            if _.isFunction(onRejected) then
                vb("\tonRejected is a function")
                local out
                local status, err = pcall( function()
                    vb("\tcalling resolve with onRejected(result))")
                    out = resolve(onRejected(result));
                end)

                if err then vb("\trejecting with err"); out = reject(err) end
                return out
            else
                vb("\tonRejected is no function. result:", tostring(result));
                local out = reject(error)
                return out
            end
        end)
    end)
    return child
end

-----------------------------------------------------------------------------------------
function exports:each(ps)

end

-----------------------------------------------------------------------------------------
return exports
