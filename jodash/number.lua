-------------------------------------------------------------------------------
-- functions that pertain to number
-------------------------------------------------------------------------------
local jo = __

-------------------------------------------------------------------------------
-- different from _.add, which takes two numbers
-- our version takes an arbitrary number of arrays and numbers
-- and sums them all
function jo.add(...)
    local args = {...}
    local length = #args
    local sum = 0

    for k,v in ipairs(args) do
        if jo.isTable(v) then
            sum = sum + jo.add(jo.unpack(v))
        else
            sum = sum + v
        end
    end

    return sum
end

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
