---@param inventoryManager InventoryManager
---@param storageSide string
---@return boolean,SupplyUser?
return function(inventoryManager, storageSide)
  local OFFHAND_SLOT = 36;
  ---@class SupplyUser
  local instance = {};
  ---@type string
  ---@diagnostic disable-next-line
  instance.name = inventoryManager.getOwner();
  if (not instance.name) then
    return false;
  end
  instance.enabled = false;
  instance.inventoryManager = inventoryManager;
  instance.storageSide = storageSide;
  ---@param force boolean?
  ---@return SupplyRet
  ---@alias SupplyRet
  ---|-3 Error
  ---|-2 Not enabled
  ---|-1 User has item in offhand
  ---|number Left totem count
  instance.supply = function(self, force)
    if not force and not self.enabled then
      return -2;
    end
    local sucessed, sentCount = pcall(
      self.inventoryManager.addItemToPlayer,
      self.storageSide, { toSlot = OFFHAND_SLOT }
    );
    if not sucessed then
      return -3
    end
    if sentCount > 0 then
      return #self.inventoryManager.listChest(self.storageSide);
    end
    return -1;
  end
  return true, instance;
end
