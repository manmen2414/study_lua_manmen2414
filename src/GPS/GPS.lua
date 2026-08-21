print("")
print("Player GPS+ v1.1.0")
print("loading...")
print("")
term.clear();
term.setCursorPos(1, 1);
_ = peripheral.find("monitor") or error("monitor not found");

---@param name string
---@param defaultValue "error"|any
---@return any | false
function SafeRequire(name, defaultValue)
    local sucessed, required = pcall(require, name);
    if (sucessed) then return required end;
    if (defaultValue == "error") then error(required); end;
    if (defaultValue) then return defaultValue end;
    return false;
end

---@type [string, number, number, number, string, number][]
local posArray = {};
local Position = SafeRequire("position", "error")
local chat = SafeRequire("chat")
local teamview = SafeRequire("teamview")
local health = SafeRequire("health")
local webhook = SafeRequire("webhook")

local framerate = 2;
local secondDelay = 1 / framerate;
local webhook_senddelay = 10;

peripheral.find("monitor").clear()
peripheral.find("monitor").setCursorPos(1, 1)
local dimensions = {
    ["minecraft:overworld"] = colors.green,
    ["minecraft:the_nether"] = colors.red
}

local buttons = {
    { 48, 54, "chat" },
    { 56, 62, "item" }
}

local function GetPressedButton(PosX)
    for index, value in ipairs(buttons) do
        if (PosX > value[1] and PosX <= value[2]) then
            return value[3]
        end
    end
    return "No Button"
end
local function repl(char, count)
    local ret = "";
    for i = 1, count, 1 do
        ret = ret .. char
    end
    return ret;
end
local function chargeText(text, count)
    return text .. repl(" ", count - #text)
end
local function MonitorWriter()
    local monitor = peripheral.find("monitor")
    for index, value in ipairs(posArray) do
        monitor.setCursorPos(1, index)
        monitor.setBackgroundColor(colors.black)
        monitor.setTextColor(colors.white);
        if teamview then
            monitor.setTextColor(teamview(value[1]))
        end
        monitor.write(chargeText(value[1], 20));
        monitor.write("->")
        monitor.setTextColor(dimensions[value[5]] or colors.white)
        monitor.write(string.format(" %-4d %-3d %-4d", value[2], value[3], value[4]))
        monitor.setTextColor(colors.white)
        monitor.write(string.format(" |%4d|", value[6]))
        if (health) then
            local PlayerHealth = health(value[1])
            if 10 < PlayerHealth then
                monitor.setTextColor(colors.lime)
            elseif 5 < PlayerHealth then
                monitor.setTextColor(colors.orange)
            else
                monitor.setTextColor(colors.red)
            end
            monitor.write(string.format("%2d", PlayerHealth))
        end
        monitor.setTextColor(colors.white)
        monitor.write("| ")
        if (chat) then
            monitor.setBackgroundColor(colors.yellow)
        else
            monitor.setBackgroundColor(colors.lightGray)
        end
        monitor.setTextColor(colors.black)
        monitor.write(" Chat ")
        monitor.setBackgroundColor(colors.black)
        monitor.write(" ")

        monitor.write(repl(" ", ({ monitor.getSize() })[1]))
    end
end
local function writeBio()
    term.clear()
    term.setCursorPos(1, 1)
    print("Player GPS+ v1.0.0")
    print("FrameRate: " .. framerate)
    if chat then
        print("Chat Addon Detected.")
    end
    if teamview then
        print("TeamView Addon Detected.")
    end
    if health then
        print("Health Addon Detected.")
    end
    if webhook then
        print("webhook Addon Detected.")
    end
end
local timerConut = 0
writeBio()
os.startTimer(secondDelay)
repeat
    local event, side, x, y = os.pullEventRaw();
    if event == "timer" then
        posArray = Position()
        MonitorWriter()
        timerConut = timerConut + 1
        if timerConut % (secondDelay * webhook_senddelay) == 0 and webhook then
            if webhook.SendPosition and #posArray > 0 then
                webhook.SendPosition(posArray, health);
            end
        end
        os.startTimer(secondDelay)
    elseif event == "monitor_touch" then
        local button = GetPressedButton(x)
        if (#posArray >= y) then
            if (button == "chat" and chat) then
                term.setCursorPos(1, 17)
                local user = posArray[y]
                print("Talk with " .. user[1])
                term.write("Name: ")
                local name = read()
                term.write("[" .. name .. "] ")
                local text = read()
                chat(user[1], name, text)
                writeBio()
                os.startTimer(framerate)
            elseif (button == "item" and ItemTeleporter) then
                ItemTeleporter.remove(posArray[y][1])
            end
        end
    elseif event == "chat" then
        if ItemTeleporter then
            if x:sub(1, 1) == ItemTeleporter.Open_Chat then
                ItemTeleporter.remove(side)
                os.startTimer(framerate)
            end
        end
        if webhook then
            if webhook.onChat then
                webhook.onChat(side, x)
                os.startTimer(framerate)
            end
        end
    elseif event == "terminate" then
        return true;
    end
until false
return true;
