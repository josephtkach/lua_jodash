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

-------------------------------------------------------------------------------
local escapeString = string.char(27) .. '[%dm'

for k,v in pairs(colorKeys) do
  colorKeys[k] = escapeString:format(v)
end

-------------------------------------------------------------------------------
getmetatable("").__index = function(str,i)
    if type(i) == 'number' then
        return string.sub(str,i,i)
    elseif type(i) == 'string' and colorKeys[i] then
        return colorKeys[i] .. str .. colorKeys.reset
    else
        return string[i]
    end
end

-------------------------------------------------------------------------------
red     = function(str) return tostring(str).red end
green   = function(str) return tostring(str).green end
yellow  = function(str) return tostring(str).yellow end
blue    = function(str) return tostring(str).blue end
magenta = function(str) return tostring(str).magenta end
cyan    = function(str) return tostring(str).cyan end
white   = function(str) return tostring(str).white end

-------------------------------------------------------------------------------
-- compatibility
local gfind = string.gfind
if _VERSION == "Lua 5.2" then gfind = string.gmatch end

-------------------------------------------------------------------------------
function string.split(str, delim, maxNb)
       if delim == '.' then delim = '%.' end
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

-------------------------------------------------------------------------------
--http://lua-users.org/wiki/StringRecipes
-------------------------------------------------------------------------------
function string.wrap(str, limit, indent, indent1)
    indent = indent or 0
    indent1 = indent1 or indent
    limit = limit or 80
    local here = 1-indent1
    
    return string.rep(" ",indent1)..str:gsub("(%s+)()(%S+)()", 
        function(sp, st, word, fi)
            if fi-here > limit then
                here = st - indent
                return "\n"..string.rep(" ", indent)..word
            end
        end
    )

end

