local CHAPTER_DELIMITER = string.rep("=", 78)
local IN_BANNER = false
local CAPTURE = false

local function found_chapter_banner_head(line)
    return line == CHAPTER_DELIMITER and IN_BANNER == false
end

local function found_chapter_banner_tail(line)
    return line == CHAPTER_DELIMITER and IN_BANNER == true
end

for line in io.lines("luacov.report.out") do
    if found_chapter_banner_head(line) then
        IN_BANNER = true
        CAPTURE = false
    elseif found_chapter_banner_tail(line) then
        IN_BANNER = false
        CAPTURE = true
    elseif IN_BANNER then
        print(line)
    elseif CAPTURE then
        if string.sub(line, 0, 5) == "****0" then
            print(line)
        end
    end
end
