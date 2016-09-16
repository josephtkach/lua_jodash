-------------------------------------------------------------------------------
local test = deepCopy( require("tests/unique") )
test.name = "Array:UniqueWith"
test.userData = { func = jo.uniqueWith }

-------------------------------------------------------------------------------
function test.Comparator(data, userData)
    local input = { {x=1,y=2}, {x=2,y=1}, {x=1,y=2} }
    
    expect( jo.uniqueWith(input, jo.isEqual) )
        :toMatchArray( {{x=1,y=2}, {x=2,y=1}} )
end

-------------------------------------------------------------------------------
return test
