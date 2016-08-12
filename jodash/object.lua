-------------------------------------------------------------------------------
local jo = __

-------------------------------------------------------------------------------
function jo.get(object, path, default, verbose)
    local paths = path:split('.')
    for i,v in ipairs(paths) do
        if not type(object) == "table" then 
            return default 
        end
        object = object[v]
    end

    -- we must do this check or we will be unable to obtain a falsey value
    if object == nil then return default end
    return object
end

-------------------------------------------------------------------------------
function jo.keys(A)
    local output = {}
    for k,v in pairs(A) do
        table.insert(output, k)
    end
    return output
end
