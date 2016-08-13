-------------------------------------------------------------------------------
-- functions that are data-structure-agnostic
-------------------------------------------------------------------------------
local jo = __

-------------------------------------------------------------------------------
local _functor = function(data, call)
    local out = jo.clone(data)

    setmetatable(out, {
        __call = call
    })
    return out
end

-------------------------------------------------------------------------------
jo.functor = _functor

-------------------------------------------------------------------------------
function jo.identity(x)
    return x
end

-------------------------------------------------------------------------------
-- mine
function jo.plainOldData(A)
    setmetatable(A, nil)
    return A
end
