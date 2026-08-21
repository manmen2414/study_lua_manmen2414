local geo = peripheral.find("geoScanner");



local function scanAllAncient()
  ---@type {name:string,x:number,y:number,z:number}[]
  local scan = geo.scan(16);
  ---@type string[]
  local list = {};
  if not scan then
    return {};
  end
  for key, value in pairs(scan) do
    if value.name == "minecraft:ancient_debris" then
      list[#list + 1] = value.x .. " " .. value.y .. " " .. value.z;
    end
  end
  return list
end



while true do
  local ancient = scanAllAncient();
  term.clear();
  term.setCursorPos(1, 1);
  for index, value in ipairs(ancient) do
    print(value)
  end
  sleep(2.1);
end
