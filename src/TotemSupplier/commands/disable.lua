return require("commandBase")()
    :addRunWord("d")
    :addRunWord("disable")
    :onExecute(
    ---@param command SupplierCommand
    ---@param args string[]
    ---@param user SupplyUser
      function(command, args, user)
        user.enabled = false;
        return "Disabled!";
      end
    )
