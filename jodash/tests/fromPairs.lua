-------------------------------------------------------------------------------
-- chunk tests
local test = junit:new({ name = "Array:FromPairs" })

-------------------------------------------------------------------------------
function test.Default(data)
    expect( jo.fromPairs({ {"a", 1}, {"b", 2} }) )
        :toMatchArray( {"a", 1, "b", 2} )
end

-------------------------------------------------------------------------------
function test.Empty(data)
    expect( jo.fromPairs({}) )
        :toMatchArray( {} )
end

-------------------------------------------------------------------------------
--should not support deep paths
function test.noDeepPaths(data)
    expect( jo.fromPairs({{"a.b", 1}}) )
        :toMatchArray( {"a.b", 1} );
end

-------------------------------------------------------------------------------
--should support consuming the return value of `jo.toPairs`
--function test.consumeToPairs(data)
    -- TODO
--end

-------------------------------------------------------------------------------
return test
