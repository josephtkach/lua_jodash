-------------------------------------------------------------------------------
local jo = __

-------------------------------------------------------------------------------
-- TODO: does not properly handle numeric indices
function jo.get(object, path, default, verbose)
    path = tostring(path)
    local paths = jo.strSplit(path, '.')
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
local function assign_inner(A, B, allowOverwrite)
    if not A then A = {} end
    if not B then return A end
    
    hash.forEach(B, function(x, k)
        local rhs = A[k]
        if rhs then
            if isTable(rhs) then
                A[k] = assign_inner(x, rhs, allowOverwrite)
            elseif allowOverwrite then
                A[k] = x 
            end
        else
            A[k] = x
        end
    end)

    return A
end

-------------------------------------------------------------------------------
function jo.clone(A, B, allowOverwrite)
    return assign_inner(A, B, allowOverwrite)
end

-------------------------------------------------------------------------------
function jo.keys(A)
    local output = {}
    for k,v in pairs(A) do
        table.insert(output, k)
    end
    return output
end
