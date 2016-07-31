-------------------------------------------------------------------------------
local ex = {}

-------------------------------------------------------------------------------
function ex.chunk(A, size)
    if not A then return A end
    if not size or size < 1 then size = 1 end

    local out = {}
    local last = nil
    local counter = size+1
    for k,v in pairs(A) do
        if counter > size then
            last = {}
            table.insert(out, last)
            counter = 1
        end

        table.insert(last, v)
        counter = counter + 1
    end

    return out
end

-------------------------------------------------------------------------------
return ex
