local SECTION_DELIMITER = string.rep("=", 78)
local NO_COV_INDICATOR = "****0"
local NO_COV_INDICATOR_LEN = string.len(NO_COV_INDICATOR)

local SECTION = ""
local IN_BANNER = false
local IN_CAPTURE = false

local function section_banner_head_found(line)
    return line == SECTION_DELIMITER and IN_BANNER == false
end

local function section_banner_tail_found(line)
    return line == SECTION_DELIMITER and IN_BANNER == true
end

local function line_is_not_covered(line)
    return string.sub(line, 0, 5) == NO_COV_INDICATOR
end

-- This is trim6 is form from: http://lua-users.org/wiki/StringTrim
function trim(s)
    return string.match(s, "^()%s*$") and '' or string.match(s, "^%s*(.*%S)")
end

local NO_COV_TO_FILE = {}

for line in io.lines("luacov.report.out") do
    if section_banner_head_found(line) then
        IN_BANNER = true
        IN_CAPTURE = false
    elseif section_banner_tail_found(line) then
        IN_BANNER = false
        IN_CAPTURE = true
    elseif IN_BANNER then
        SECTION = line
        NO_COV_TO_FILE[SECTION] = {}
    elseif IN_CAPTURE then
        if line_is_not_covered(line) then
            table.insert(NO_COV_TO_FILE[SECTION], trim(string.sub(line, NO_COV_INDICATOR_LEN + 1)))
        end
    end
end

for k, v in pairs(NO_COV_TO_FILE) do
    for _, s in ipairs(v) do
        print(k, s)
    end
end
