-----------------------------------------------------------------------------------------
-- allocator.lua
-- factory for object pools
-----------------------------------------------------------------------------------------
local _ = require("../jodash/index")
-----------------------------------------------------------------------------------------
local exports = {}

-- debugging option
exports.detectDoubleFrees = true

-----------------------------------------------------------------------------------------
exports.__call = function(self, ctor, dtor)
    local out = {}
    out.__ctor = ctor
    out.__dtor = dtor
    return out
end

-----------------------------------------------------------------------------------------
local _remove = table.remove -- optimization
-----------------------------------------------------------------------------------------
function exports:new(...)
    local out = _.pop(self.__pool) or {}
    self.__ctor(out, ...)
    return out
end

-----------------------------------------------------------------------------------------
function exports:release(x)
    if exports.detectDoubleFrees and _.indexOf(self.__pool, x) ~= -1 then
        print("WARNING: tried to double-free ", tostring(x))
    end

    self.__dtor(x)
    self.__pool = _.append(self.__pool, x)
end

-----------------------------------------------------------------------------------------
return exports
