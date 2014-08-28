local SECTION_DELIMITER = string.rep("=", 78)
local NO_COV_INDICATOR = "^\*+0%s*(.*)$"

local SECTION = ""
local IN_BANNER = false
local IN_FILE_SCETION = false
local IN_CAPTURE = false
local LINE_COUNTER = 0

local SUMMARY = {}
local NO_COV_TO_FILE = {}

local function basename(file_path)
    return string.match(file_path, ".*/(.*)")
end

-- This is trim6 is form from: http://lua-users.org/wiki/StringTrim
function trim(s)
    return string.match(s, "^()%s*$") and '' or string.match(s, "^%s*(.*%S)")
end

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
    return string.match(line, NO_COV_INDICATOR)
end

local function file_summary_found(line)
    return string.match(line, "^%d+%s+%d+%s+[%d%p]+%s+[%w%p]+$")
end

local function store_not_covered_line(line_nr, line)
    local array = NO_COV_TO_FILE[SECTION]
    local code = trim(string.match(line, NO_COV_INDICATOR))
    local value = string.format("%5d %s", line_nr, code)
    table.insert(array, value)
end

local function store_file_summary(line)
    local percent = string.match(line, "%d+%s+%d+%s+(.*)%s+.*")
    local file_name = basename(string.match(line, "%d+%s+%d+%s+.*%s+(.*)"))
    SUMMARY[file_name] = percent
end

for line in io.lines("luacov.report.out") do
    if banner_head_found(line) then
        IN_BANNER = true
        IN_CAPTURE = false
        IN_FILE_SCETION = false
        IN_SUMMARY_SECTION = false
        LINE_COUNTER = 0
    elseif file_section_found(line) then
        IN_FILE_SCETION = true
        SECTION = basename(line)
        NO_COV_TO_FILE[SECTION] = {}
    elseif summary_section_found(line) then
        IN_SUMMARY_SECTION = true
    elseif banner_tail_found(line) then
        IN_BANNER = false
        IN_CAPTURE = true
    elseif in_file_content_section() then
        LINE_COUNTER = LINE_COUNTER + 1
        if line_is_not_covered(line) then
            store_not_covered_line(LINE_COUNTER, line)
        end
    elseif in_summary_content_section() then
        if file_summary_found(line) then
            store_file_summary(line)
        end
    end
end

print(string.format("%s\n%s", "Coverage report", SECTION_DELIMITER))
for k, v in pairs(SUMMARY) do
    print(string.format("%7s  %s", v, k))
    for _, s in ipairs(NO_COV_TO_FILE[k]) do
        print(string.format("    NOT covered: %s", s))
    end
end
