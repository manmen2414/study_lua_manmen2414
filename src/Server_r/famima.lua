local count = 0
while true do
    if redstone.getInput("front") then
        count = count + 1
        shell.execute("speaker", "play",
            "https://cdn.discordapp.com/attachments/1204033389200678953/1204036147429507072/-.dfpwm")
        sleep(10)
    end
    term.clear()
    term.setCursorPos(1, 1)
    print("Count : " .. count)
    sleep(0.5)
end
