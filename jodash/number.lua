-------------------------------------------------------------------------------
-- functions that pertain to number
-------------------------------------------------------------------------------
local jo = __

-------------------------------------------------------------------------------
function jo.clamp(number, lower, upper)
    if upper == nil then 
        upper = lower
        lower = number
    end

    if number < lower then return lower end
    if number > upper then return upper end
    return number
end
