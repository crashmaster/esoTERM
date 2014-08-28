local SECTION_DELIMITER = string.rep("=", 78)
local NO_COV_INDICATOR = "****0"
local NO_COV_INDICATOR_LEN = string.len(NO_COV_INDICATOR)

local SECTION = ""
local IN_BANNER = false
local IN_FILE_SCETION = false
local IN_CAPTURE = false

local function banner_head_found(line)
    return line == SECTION_DELIMITER and not IN_BANNER
end

local function file_section_found(line)
    return string.match(line, "^.*\.lua$") and IN_BANNER
end

local function summary_section_found(line)
    return string.match(line, "^Summary$") and IN_BANNER
end

local function banner_tail_found(line)
    return line == SECTION_DELIMITER and IN_BANNER
end

local function in_file_content_section()
    return not IN_BANNER and IN_CAPTURE and IN_FILE_SCETION
end

local function in_summary_content_section()
    return not IN_BANNER and IN_CAPTURE and IN_SUMMARY_SECTION
end

local function line_is_not_covered(line)
    return string.sub(line, 0, 5) == NO_COV_INDICATOR
end

local function basename(file_path)
    return string.match(file_path, ".*/(.*)")
end

-- This is trim6 is form from: http://lua-users.org/wiki/StringTrim
function trim(s)
    return string.match(s, "^()%s*$") and '' or string.match(s, "^%s*(.*%S)")
end

local SUMMARY = {}
local NO_COV_TO_FILE = {}

for line in io.lines("luacov.report.out") do
    if banner_head_found(line) then
        IN_BANNER = true
        IN_CAPTURE = false
        IN_FILE_SCETION = false
        IN_SUMMARY_SECTION = false
    elseif file_section_found(line) then
        IN_FILE_SCETION = true
        SECTION = basename(line)
        NO_COV_TO_FILE[SECTION] = {}
    elseif summary_section_found(line) then
        IN_SUMMARY_SECTION = true
    elseif banner_tail_found(line) then
        IN_BANNER = false
        IN_CAPTURE = true
    elseif in_file_content_section() and line_is_not_covered(line) then
        local array = NO_COV_TO_FILE[SECTION]
        local value = trim(string.sub(line, NO_COV_INDICATOR_LEN + 1))
        table.insert(array, value)
    elseif in_summary_content_section() then
        if string.match(line, ".*%s+.*%s+.*%s+.*") then
            print(string.match(line, "%d+%s+%d+%s+(.*)%s+.*"))
            print(string.match(line, "%d+%s+%d+%s+.*%s+(.*)"))
        end
    end
end

for k, v in pairs(NO_COV_TO_FILE) do
    for _, s in ipairs(v) do
        print(k, s)
    end
end
