---@type InventoryManager[]
local inventoryManagers = { peripheral.find("inventoryManager") };
---@type ChatBox
local chatBox = peripheral.find("chatBox");
local SupplyUser = require("supplyuser");
local side = "left";
local systemName = "Totem Supplier";

---@type SupplyUser[]
local users = {};
---@type SupplierCommand[]
local commands = {};

for _, commandFile in pairs(fs.list("./commands")) do
  commands[#commands + 1] = require("commands." .. string.match(commandFile, "[^\\.]+"));
end

---@param inputstr string
---@param sep string
---@return string[]
local function split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

local resetCount = 0;

local function initUser()
  local newUsers = {};
  for _, manager in pairs(inventoryManagers) do
    local _, newUser = SupplyUser(manager, side);
    if not not newUser then
      ---@type SupplyUser
      local addUserInstance = newUser;
      for _, oldUser in ipairs(users) do
        if oldUser.name == newUser.name then
          addUserInstance = oldUser;
        end
      end
      newUsers[#newUsers + 1] = addUserInstance;
    end
  end
  users = newUsers;
end

local function tick()
  local processed = false;
  for _, user in pairs(users) do
    local result = user:supply();
    if result ~= -2 then
      processed = true;
    end
    if (result >= 0) then
      chatBox.sendToastToPlayer("Left totem: " .. result, systemName, user.name);
    end
  end
  resetCount = resetCount + 1;
  if resetCount > 39 then
    resetCount = 0;
    initUser();
  end
  return processed;
end
local function mainLoop()
  repeat
    if not tick() then
      sleep(0.05);
    end
  until false
end
local function waitCommand()
  repeat
    ---@type "chat",string,string
    local event, username, message = os.pullEvent("chat")
    for _, user in pairs(users) do
      if user.name == username then
        for _, command in pairs(commands) do
          local index = command:checkCommand(message);
          if index ~= 0 then
            local result = command:execute(split(message, " "), user);
            if #result ~= 0 then
              chatBox.sendMessageToPlayer(result, username, systemName, "[]");
            end
          end
        end
      end
    end
  until false
end

initUser();
parallel.waitForAll(mainLoop, waitCommand)
