-------------------------------------------------------------------------------
-- test harness code
local exports = {}
exports.__index = exports

-------------------------------------------------------------------------------
local function hr()
    print("-------------------------------------------------------------------------------")
end

-------------------------------------------------------------------------------
function exports:run()
    hr()
    print("Running test: " .. self.name)
    hr()

    for k,v in pairs(self) do
        print(k)
        
        trycatch(v, function()
            print( tostring("Failed").red )
        end)

        hr()
    end
end

-------------------------------------------------------------------------------
function exports:new(params)
    local outmt = deepCopy(params) 
    setmetatable(outmt, exports)

    local out = {}
    setmetatable(out, outmt)
    return out
end


-------------------------------------------------------------------------------
return exports
