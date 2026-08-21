---@type Modem?
local modem = peripheral.find("modem");

if not modem then
  error("This program need any modem");
end

local port = 26316;


while true do
  term.clear();
  term.setCursorPos(1, 1);
  print("W to forward");
  print("A,D to turn");
  print("(UP)S,(DN)X to move Y");
  print("H,(UP)Y,(DN)N to break");
  print("J,(UP)U,(DN)M to place");
  print("K to select slot");
  print("R to refuel");
  print("F to run function");
  ---@type any,number
  local _, key = os.pullEvent("key");
  if key == keys.w then
    modem.transmit(port, 0, { act = "forward", value = 0 })
  elseif key == keys.a then
    modem.transmit(port, 0, { act = "left", value = 0 })
  elseif key == keys.d then
    modem.transmit(port, 0, { act = "right", value = 0 })
  elseif key == keys.s then
    modem.transmit(port, 0, { act = "up", value = 0 })
  elseif key == keys.x then
    modem.transmit(port, 0, { act = "down", value = 0 })
  elseif key == keys.h then
    modem.transmit(port, 0, { act = "dig", value = 0 })
  elseif key == keys.y then
    modem.transmit(port, 0, { act = "digUp", value = 0 })
  elseif key == keys.n then
    modem.transmit(port, 0, { act = "digDown", value = 0 })
  elseif key == keys.k then
    term.write(" Select Slot(1-16): ");
    local slotStr = read();
    local slot = tonumber(slotStr)
    if not slot or slot < 1 or slot > 16 then
      print("Canceled.")
      sleep(0.5)
    else
      modem.transmit(port, 0, { act = "select", value = slot })
    end
  elseif key == keys.j then
    modem.transmit(port, 0, { act = "place", value = 0 })
  elseif key == keys.u then
    modem.transmit(port, 0, { act = "placeUp", value = 0 })
  elseif key == keys.m then
    modem.transmit(port, 0, { act = "placeDown", value = 0 })
  elseif key == keys.f then
    print(" Run lua code:");
    local func = read();
    modem.transmit(port, 0, { act = "eval", value = func })
  elseif key == keys.r then
    modem.transmit(port, 0, { act = "refuel", value = 0 })
  end
end
