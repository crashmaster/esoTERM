local SECTION_DELIMITER = string.rep("=", 78)
local NO_COV_INDICATOR = "^%*+0%s*(.*)$"
local MAX_CODE_LEN = 65

local SECTION = ""
local IN_BANNER = false
local IN_FILE_SECTION = false
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
    return string.match(line, "^.*%.lua$") and IN_BANNER
end

local function summary_section_found(line)
    return string.match(line, "^Summary$") and IN_BANNER
end

local function banner_tail_found(line)
    return line == SECTION_DELIMITER and IN_BANNER
end

local function in_file_content_section()
    return not IN_BANNER and IN_CAPTURE and IN_FILE_SECTION
end

local function in_summary_content_section()
    return not IN_BANNER and IN_CAPTURE and IN_SUMMARY_SECTION
end

local function line_is_not_covered(line)
    return string.match(line, NO_COV_INDICATOR)
end

local function file_summary_found(line)
    return string.match(line, "^.*%.lua%s+%d+%s+%d+%s+%d+%.%d+%%$")
end

local function truncate_if_long(string)
    if #string < MAX_CODE_LEN then
        return string
    end
    return string.sub(string, 0, MAX_CODE_LEN - 3) .. "..."
end

local function store_not_covered_line(line_nr, line)
    local array = NO_COV_TO_FILE[SECTION]
    local code = truncate_if_long(trim(string.match(line, NO_COV_INDICATOR)))
    local value = string.format("%5d %s", line_nr, code)
    table.insert(array, value)
end

local function store_file_summary(line)
    local percentage = string.match(line, "^.*%.lua%s+%d+%s+%d+%s+(%d+%.%d+%%)$")
    local file_name = basename(string.match(line, "^(.*%.lua)%s+%d+%s+%d+%s+%d+%.%d+%%$"))
    SUMMARY[file_name] = percentage
end

local function parse_luacov_report_file(file)
    for line in io.lines(file) do
        if banner_head_found(line) then
            IN_BANNER = true
            IN_CAPTURE = false
            IN_FILE_SECTION = false
            IN_SUMMARY_SECTION = false
            LINE_COUNTER = 0
        elseif file_section_found(line) then
            IN_FILE_SECTION = true
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
end

local function print_output()
    sorted_by_file_name = {}
    for n in pairs(SUMMARY) do
        table.insert(sorted_by_file_name, n)
    end
    table.sort(sorted_by_file_name)
    print(string.format("%s\n%s", "Coverage report", SECTION_DELIMITER))
    for i, file_name in ipairs(sorted_by_file_name) do
        percentage = SUMMARY[file_name]
        print(string.format("%-30s  %s", file_name, percentage))
        if #NO_COV_TO_FILE[file_name] > 0 then
            print("    NOT covered lines:")
            for _, not_covered_line in ipairs(NO_COV_TO_FILE[file_name]) do
                print(string.format("     %s", not_covered_line))
            end
        end
    end
end

local function main(luacov_report_file)
    parse_luacov_report_file(luacov_report_file)
    print_output()
end

if arg[1] then
    main(arg[1])
else
    io.stderr:write("No luacov report file given!\n")
end
