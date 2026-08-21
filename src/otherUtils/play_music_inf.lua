local args = { ... };
local musics = {}

---@param readpath string
local function loadList(readpath)
    local path = readpath;
    if not fs.exists(path) then
        path = path .. ".mplaylist";
    end
    local file = fs.open(path, "r")
    local skipped = false
    while true do
        local line = file.readLine()
        if not line then break end
        if skipped then
            musics[#musics + 1] = line
            print("Adding music...")
        else
            skipped = true
        end
    end
    file.close()
end

while true do
    if args[1] then
        loadList(args[1])
        break;
    end
    term.clear()
    term.setCursorPos(1, 1)
    print("You can get .dfpwm file on \nhttps://music.madefor.cc/")
    print("You have " .. #musics .. " music(s)")
    print("Type 'end':Play")
    print("Type 'save':Save Playlist")
    print("Type 'load':Load Playlist")
    print("Please URL or command:")
    local musicurl = read()
    if musicurl == "end" then
        break
    elseif musicurl == "save" then
        local text = ""
        print("Please type name")
        local path = read()
        print("[" .. path .. ".mplaylist] OK?(y/n)")
        local check = read()
        if check == "y" then
            for index, value in next, musics do
                text = text .. "\n" .. value
                print("Writing music" .. index)
            end
            local file = fs.open(path .. ".mplaylist", "w")
            file.write(text)
            file.close()
            print("-End!")
        end
    elseif musicurl == "load" then
        term.clear()
        term.setCursorPos(1, 1)
        print("Please type .mplaylist path")
        local readpath = read()
        loadList(readpath);
        print("-End!")
    else
        musics[#musics + 1] = musicurl
        print("Adding music...")
    end
    --print(3)
    sleep(0.5)
end
local i = 0

while true do
    for index, value in next, musics do
        --print(4)
        term.clear()
        term.setCursorPos(1, 1)
        print("I am playing " .. i .. " time(s).\nhold CTRL+R:end\nhold CTRL+T:next")
        shell.execute("speaker", "play", value)
        --print(5)
    end
    --print(6)
    sleep(0.5)
    i = i + 1
    --print(7)
end
