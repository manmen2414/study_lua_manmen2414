--- [Environment File Needed] env_dev.lua -> env.lua

---@param name string
---@param defaultValue "error"|any
---@return any | false
local function SafeRequire(name, defaultValue)
  local sucessed, required = pcall(require, name);
  if (sucessed) then return required end;
  if (defaultValue == "error") then error(required); end;
  if (defaultValue) then return defaultValue end;
  return false;
end

---@param name string
---@param url string
local function getPackage(name, url)
  local package = SafeRequire(name)
  if not package then
    shell.run("wget",
      url,
      name .. ".lua");
    return require(name);
  end
  return package;
end

local env = getPackage("env",
  "https://raw.githubusercontent.com/manmen2414/AKKI-Server-MameeennArea/refs/heads/main/Match_2026/ItemWarning/env-dev.lua")
local WebhookDiscord = getPackage("WebhookDiscord",
  "https://raw.githubusercontent.com/manmen2414/Smali_CCTPrograms/refs/heads/main/src/Discord_Webhook/WebhookDiscord.lua")
local CreateEmbed = getPackage("CreateEmbed",
  "https://raw.githubusercontent.com/manmen2414/Smali_CCTPrograms/refs/heads/main/src/Discord_Webhook/CreateEmbed.lua")
local pretty = require("cc.pretty");
local PercentageError = env.PERCENTAGE_ERROR;
local PercentageClean = env.PERCENTAGE_CLEAN;
local Name = env.NAME;

---@param t table
---@return number
local function getTableSize(t)
  local count = 0
  for _ in pairs(t) do
    count = count + 1
  end
  return count;
end



---@return {used:number,limit:number}
---@param storage Inventory
local function getLimitAndUsedSlots(storage)
  local list = storage.list()
  local used = getTableSize(list)
  local limit = storage.size();
  return {
    used = used, limit = limit
  }
end

local function reportOccupied()
  WebhookDiscord(env.DISCORD_WEBHOOK, nil, nil, nil, {
    CreateEmbed.Embed(Name, "More " .. PercentageError .. "% slots at storage `" .. Name .. "` has occupied.", nil, nil,
      0xee3333, nil,
      nil, nil,
      nil,
      { name = env.name }, nil)
  })
end

local function reportClean()
  WebhookDiscord(env.DISCORD_WEBHOOK, nil, nil, nil, {
    CreateEmbed.Embed(Name, "Storage `" .. Name .. "` has no longer occupied.", nil, nil, 0x33ee33, nil, nil,
      nil,
      nil,
      { name = env.name }, nil)
  })
end

---@type "Clean"|"Occupied"
local stat = "Clean"
repeat
  ---@type Inventory[]
  local storages = { peripheral.find("inventory") }
  local limit = 0;
  local used = 0;
  for index, storage in ipairs(storages) do
    local data = getLimitAndUsedSlots(storage)
    limit = limit + data.limit;
    used = used + data.used;
  end
  local usedPercent = used / limit * 100;
  local isOccupied = PercentageError <= usedPercent;
  local isClean = usedPercent <= PercentageClean;
  if PercentageError == PercentageClean then
    isClean = usedPercent < PercentageClean
  end
  if isOccupied and stat == "Clean" then
    stat = "Occupied";
    reportOccupied();
  elseif isClean and stat == "Occupied" then
    stat = "Clean";
    reportClean()
  end
  term.clear();
  term.setCursorPos(1, 1);

  pretty.pretty_print({
    stat = stat,
    storagesCount = #storages,
    usedPercent = usedPercent,
    storageSlots = limit,
    usedSlots = used,
    env = {
      DISCORD_WEBHOOK = "__HIDDEN__",
      NAME = env.NAME,
      PERCENTAGE_ERROR = env.PERCENTAGE_ERROR,
      PERCENTAGE_CLEAN = env.PERCENTAGE_CLEAN
    }
  })
  sleep(0.05)
until false
