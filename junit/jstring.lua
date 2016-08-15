-------------------------------------------------------------------------------
-- string manipulation
-------------------------------------------------------------------------------
local colorKeys = {
	-- reset
	reset =      0,

	-- misc
	bright     = 1,
	dim        = 2,
	underline  = 4,
	blink      = 5,
	reverse    = 7,
	hidden     = 8,

	-- foreground colors
	black     = 30,
	red       = 31,
	green     = 32,
	yellow    = 33,
	blue      = 34,
	magenta   = 35,
	cyan      = 36,
	white     = 37,

	-- background colors
	blackbg   = 40,
	redbg     = 41,
	greenbg   = 42,
	yellowbg  = 43,
	bluebg    = 44,
	magentabg = 45,
	cyanbg    = 46,
	whitebg   = 47
}

local escapeString = string.char(27) .. '[%dm'

for k,v in pairs(colorKeys) do
  colorKeys[k] = escapeString:format(v)
end

getmetatable("").__index = function(str,i)
    if type(i) == 'number' then
        return string.sub(str,i,i)
    elseif type(i) == 'string' and colorKeys[i] then
        return colorKeys[i] .. str .. colorKeys.reset
    else
        return string[i]
    end
end