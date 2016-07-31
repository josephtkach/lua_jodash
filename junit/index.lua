-------------------------------------------------------------------------------
-- test harness code
-------------------------------------------------------------------------------
local exports = {}
exports.__index = exports

-------------------------------------------------------------------------------
require("junit/utils")
require("junit/jstring")

-------------------------------------------------------------------------------
local function hr()
    print("-------------------------------------------------------------------------------")
end

-------------------------------------------------------------------------------
local s = tostring

-------------------------------------------------------------------------------
exports.data = {}
-- todo: make a factor for objects of this type
setmetatable(exports.data, { __index = function(self, key)
    return deepCopy(rawget(self, key))
end })

-------------------------------------------------------------------------------
exports.data.empty = {}

-------------------------------------------------------------------------------
exports.data.alphabet = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' }

-------------------------------------------------------------------------------
exports.data.ten = {}
for i = 1,10 do
    exports.data.ten[i] = tostring(i)
end

-------------------------------------------------------------------------------
function exports:run()
    hr()
    print("Running test: " .. self.name)
    hr()

    for k,v in pairs(self) do
        print(k.green)
        local failed = false
        
        tryCatch( function()
            v(self.data)
        end, function()
            failed = true
            print( s("Failed").red )
        end)

        if not failed then print( s("Succeeded").green ) end
        hr()
    end
end

-------------------------------------------------------------------------------
function exports:new(params)
    local outmt = deepCopy(params)
    outmt.__index = outmt
    setmetatable(outmt, exports)

    local out = {}
    setmetatable(out, outmt)
    return out
end


-------------------------------------------------------------------------------
return exports
