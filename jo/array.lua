-------------------------------------------------------------------------------
local ex = {}

-------------------------------------------------------------------------------
function ex.chunk(A, size)
    if not A then return A end
    size = size or 1

    local out = {}
    local last = nil
    local counter = size
    for k,v in pairs(A) do
        if counter > size then
            last = {}
            table.insert(last)
            counter = 1
        end

        table.insert(last, v)
        counter = counter + 1
    end
end

-------------------------------------------------------------------------------
return ex
