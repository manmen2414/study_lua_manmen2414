return function()
  ---@class SupplierCommand
  local instance = {};
  ---@type string[]
  instance.runWords = {};
  ---@param command SupplierCommand
  ---@param args string[]
  ---@param user SupplyUser
  ---@return string
  instance.execute = function(command, args, user)
    return "";
  end
  ---@param func function
  instance.onExecute = function(self, func)
    self.execute = func;
    return self;
  end
  ---@param str string
  instance.addRunWord = function(self, str)
    self.runWords[#self.runWords + 1] = str;
    return self;
  end
  ---@param str string
  instance.checkCommand = function(self, str)
    local commandWord = str:match("[^ ]+");
    for index, word in ipairs(self.runWords) do
      if word == commandWord then
        return index;
      end
    end
    return 0;
  end
  return instance;
end
