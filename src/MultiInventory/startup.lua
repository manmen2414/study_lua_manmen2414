---@type InventoryManager[]
local inventoryManagers = { peripheral.find("inventory_manager") };
---@type ChatBox
local chatBox = peripheral.find("chat_box");

---@param str string
---@param ts string
---@return string[]
---https://qiita.com/gp333/items/c472f7a7d9fcca1b5cb7
function string.split(str, ts)
  if ts == nil then return {} end
  local t = {};
  local i = 1
  for s in string.gmatch(str, "([^" .. ts .. "]+)") do
    t[i] = s
    i = i + 1
  end

  return t
end

if not chatBox then
  error("no chatbox")
end

local function move(from)
  local fromStr, toStr = table.unpack(content:split(">"))
  local from = toSide(fromStr);
  local to = toSide(toStr);
  for i = 0, 27, 1 do
    if to ~= "" then
      inventoryManagers.removeItemFromPlayer(to, { fromSlot = i + 9, toSlot = i });
    end
    if from ~= "" then
      inventoryManagers.addItemToPlayer(from, { fromSlot = i, toSlot = i + 9 });
    end
  end
end

---@param content string
local function command(content)

end

repeat
  ---@type "chat",string,string
  local event, username, message = os.pullEvent("chat")
  for _, manager in ipairs(inventoryManagers) do
    local ownerName = manager.getOwner();
    if ownerName == username and message:match("^inv") then
      command(message:sub(4));
    end
  end
until false
