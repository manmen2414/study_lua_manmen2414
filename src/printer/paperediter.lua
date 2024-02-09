local printer = peripheral.find("printer")

-- Start a new page, or print an error.
if not printer.newPage() then
    error("Cannot start a new page. Do you have ink and paper?")
end
local cur = 1
local first = true;
while true do
    -- Write to the page
    if first then
        print("Paper name:")
        local input = read()
        printer.setPageTitle(input)
        print("---------------")
    else
        local input = read()
        printer.setCursorPos(1, cur)
        printer.write("")
        if input == "!end!" then
            -- And finally print the page!
            if not printer.endPage() then
                error("Cannot end the page. Is there enough space?")
            end
            break;
        end
    end
end