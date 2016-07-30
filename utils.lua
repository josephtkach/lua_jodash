-------------------------------------------------------------------------------
-- from http://lua-users.org/wiki/CopyTable
function deepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepCopy(orig_key)] = deepCopy(orig_value)
        end
        setmetatable(copy, deepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-------------------------------------------------------------------------------
function tryCatch(try, catch)
    if not pcall(try) then
        catch()
        print(" at ")
        print(debug.traceback())
    end
end
