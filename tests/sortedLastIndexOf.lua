-------------------------------------------------------------------------------
local test = junit:new({ name = "Array:SortedLastIndexOf" })

-------------------------------------------------------------------------------
function test.OneToTen(data)
    for i,v in ipairs(data.ten) do
        expect( jo.sortedLastIndexOf(data.ten, v) ):toBe(i)
    end
end

-------------------------------------------------------------------------------
function test.WithDuplicate(data)
    local input = { 1,2,3,3,4,5 }
    expect( jo.sortedLastIndexOf(input, 3) ):toBe(4)
end

-------------------------------------------------------------------------------
function test.TableSizeOne(data)
    expect( jo.sortedLastIndexOf({ 1 }, 1) ):toBe(1)
end

-------------------------------------------------------------------------------
function test.Empty(data)
    expect( jo.sortedLastIndexOf(data.empty, 1) ):toBe(-1)
end

-------------------------------------------------------------------------------
function test.AllTheSameValue(data)
    local input = { 10, 10, 10, 10, 10 }
    expect( jo.sortedLastIndexOf(input, 10) ):toBe(5)
end


-------------------------------------------------------------------------------
return test
