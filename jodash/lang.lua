-------------------------------------------------------------------------------
local jo = __

-------------------------------------------------------------------------------
local _functor = function(data, call)
    local out = jo.hash.clone(data)

    setmetatable(out, {
        __call = call
    })
    return out
end

-------------------------------------------------------------------------------
jo.functor = _functor

-------------------------------------------------------------------------------
local function _isArray(A)
    if #A == 0 then
        for k,v in pairs(A) do
            return false
        end
    end
    return true
end

-------------------------------------------------------------------------------
jo.isArray = _functor({ dangerous = _isArray },
    function(self, A)
        for k,v in pairs(self) do
            print(tostring(k) .. " : " .. tostring(v))
        end

        if A == nil or type(A) ~= "table" then return false end
        return self.dangerous(A)
    end
)

-------------------------------------------------------------------------------
function jo.isEmpty(A)
    return not A or next(A) == nil
end

-------------------------------------------------------------------------------
function jo.isFalsey(A)
    return A == nil
        or A == false
        or A == ""
        or A == 0
        --or isNan(A) -- todo: bind a C++ NaN check
end

-------------------------------------------------------------------------------
function jo.isTable(A)
    return type(A) == "table"
end

-------------------------------------------------------------------------------
function jo.isTruthy(A)
    return not jo.isFalsey(A)
end

-------------------------------------------------------------------------------
function jo.swap(A,B)
    return B, A
end

-------------------------------------------------------------------------------
function jo.toArray(A)
    local output = set.new()
    for k,v in pairs(A) do
        table.insert(output, v)
    end
    return output
end
