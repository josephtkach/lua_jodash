--------------------------------------------------------------------------------
-- debugging tool
--------------------------------------------------------------------------------
local jo = __

--------------------------------------------------------------------------------
local function index(self, key)
    local mt = getmetatable(self)
    return mt.original[key]
end

--------------------------------------------------------------------------------
local function replaceWithProxy(object, newindex)
    local original = {}
    for k,v in pairs(object) do
        original[k] = v
        object[k] = nil
    end
    setmetatable(original, getmetatable(object))

    ----------------------------------------------------------------------------
    setmetatable(object, { 
        readonly = true, 
        original = original, 
        __index = index, 
        __newindex = newindex
    })
end

--------------------------------------------------------------------------------
--  options: 
--      recursive - create the proxy recursively
function jo.watch(object, field, options)
    print("setting a watch on " .. tostring(object) .. "." .. tostring(field))
    local function watchNewIndex(self, key, value)
        if not field or key == field then
            local oldValue = rawget(getmetatable(object).original, key)
            warn("modified key: " .. key .. " on table: " .. tostring(self)
                .. "\nold value: " .. tostring(oldValue)
                .. "\nnew value: " .. tostring(value))
        end
        rawset(getmetatable(object).original, key, value)
    end

    replaceWithProxy(object, watchNewIndex)
end

-------------------------------------------------------------------------------
function jo.print(A, label)
    if not A then return A end
    if label then print(label) end
    printTable(A, 99)
    return A
end
