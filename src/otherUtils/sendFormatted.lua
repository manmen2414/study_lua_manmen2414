local contents = {
  indihome =
  '["\n",{"text":"        IndiHome","bold":true},{"text":"\n"},{"text":"        Paket Phonix\n","bold":true,"color":"#FF0000"},{"text":"\nPaket Phonix  Rp 280.000\n     ","color":"#FF0000"},{"text":"10 Mbps        /bulan\n"},{"text":"Paket Phonix  Rp 345.000\n     ","color":"#FF0000"},{"text":"20 Mbps        /bulan\n"},{"text":"Paket Phonix  Rp 575.000\n     ","color":"#FF0000"},{"text":"50 Mbps        /bulan\n"},{"text":"Paket Phonix  Rp 935.000\n    ","color":"#FF0000"},{"text":"100 Mbps        /bulan"}]',
  germ =
  '["\n",{"text":"####################\n####################","bold":true,"color":"black"},{"text":"\n","bold":true},{"text":"####################\n####################","bold":true,"color":"#FF0003"},{"text":"\n","bold":true},{"text":"####################\n####################","bold":true,"color":"#FBCC00"}]'
  ,
  ww =
  '["\n",{"text":"===========================","bold":true},{"text":"\n"},{"text":"|","bold":true},{"text":" The March Server World War","bold":true},{"text":" |","bold":true},{"text":"\n"},{"text":"===========================","bold":true},{"text":"\n\n"},{"text":"Viridia","color":"green"},{"text":"+Minecrant ","color":"red"},{"text":"Union","color":"gold"},{"text":" vs"},{"text":" Laputa Team","color":"blue"},{"text":"\nIn. 3/31 12:00 ~ 4/1 0:00\n\n\n"},{"text":"@@@ START !!!! @@@","bold":true,"color":"yellow"}]',
  watw =
  '{"text":"\nWe are the world, we are the children,\nWe are the ones who make a brighter day,\nSo lets start giving.\nThere\'s a choice we\'re making,\nWe\'re saving our own lives.\nIt\'s true we\'ll make a better day,\nJust you and me."}',
  fa =
  '["",{"text":"\n"},{"text":"@@@ DON\'T PARDON FaxAnarouter!! @@@","bold":true},{"text":"\n\nThe president of FaxAnarouter, "},{"selector":"AutumnMouse578"},{"text":" committed multiple crimes.\nAirspace violation, Killing of foreigners, A plot to overthrow the government, etc...\nCan you overlook these actions?\n\n"},{"text":"Now is the time to take action!\nLet\'s destroy FaxAnarouter and win this war!","bold":true}]',
  gps =
  '["",{"text":"Daiki GPS For Free: ","bold":true},{"text":"https://home.akkiserver.uk","underlined":true,"color":"blue","clickEvent":{"action":"open_url","value":"https://home.akkiserver.uk"}}]',
}

---@type ChatBox
local chatBox = peripheral.find("chatBox")
local owner = "AM_107ryu";

local prefix = "&0|";
local brackets = "||";
local braketColor = "&0";



---@param contentId string
local function sendMessage(contentId)
  local content = contents[contentId];
  if not content then
    return;
  end
  chatBox.sendFormattedMessage(content, prefix, brackets, braketColor)
end

---@param contentId string
local function sendMessageOwner(contentId)
  local content = contents[contentId];
  if not content then
    return;
  end
  chatBox.sendFormattedMessageToPlayer(content, owner, prefix, brackets, braketColor)
end

---@param message string
local function testMessage(message)
  local start2 = message:sub(1, 2);
  if start2 == "s:" then
    sendMessage(message:sub(3));
  elseif start2 == "S:" then
    sendMessageOwner(message:sub(3));
  end
end

repeat
  ---@type "chat",string,string
  local event, username, message = os.pullEvent("chat")
  if username == owner then
    testMessage(message);
  end
until false
