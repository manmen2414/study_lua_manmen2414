return require("commandBase")()
    :addRunWord("e")
    :addRunWord("enable")
    :onExecute(
    ---@param command SupplierCommand
    ---@param args string[]
    ---@param user SupplyUser
      function(command, args, user)
        user.enabled = true;
        return "Enabled!";
      end
    )
