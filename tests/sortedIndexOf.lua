-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:sortedIndexOf" })

-------------------------------------------------------------------------------
function test.OneToTen(data)
    for i,v in ipairs(data.ten) do
        expect( jo.sortedIndexOf(data.ten, v) ):toBe(i)
    end
end

-------------------------------------------------------------------------------
function test.WithDuplicate(data)
    local input = { 1,2,3,3,4,5 }
    expect( jo.sortedIndexOf(input, 3) ):toBe(3)
end

-------------------------------------------------------------------------------
function test.TableSizeOne(data)
    expect( jo.sortedIndexOf({ 1 }, 1) ):toBe(1)
end

-------------------------------------------------------------------------------
function test.Empty(data)
    expect( jo.sortedIndexOf(data.empty, 1) ):toBe(-1)
end

-------------------------------------------------------------------------------
function test.AllTheSameValue(data)
    local input = { 10, 10, 10, 10, 10 }
    expect( jo.sortedIndexOf(input, 10) ):toBe(1)
end


-------------------------------------------------------------------------------
return test
