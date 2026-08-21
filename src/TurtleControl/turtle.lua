---@type Modem?
local modem = peripheral.find("modem");

if not turtle then
  error("This program can run only turtle");
end
if not modem then
  error("This program need any modem");
end

modem.open(26316);

while true do
  ---@type any,any,number,any,{act:"forward"|"left"|"right"|"up"|"down"|"dig"|"digUp"|"digDown"|"select"|"place"|"placeUp"|"placeDown"|"eval"|"refuel",value:string|number},number
  local _, _, ch, _, message, dis = os.pullEvent("modem_message");
  if message.act == "forward" then
    turtle.forward();
  elseif message.act == "left" then
    turtle.turnLeft();
  elseif message.act == "right" then
    turtle.turnRight();
  elseif message.act == "up" then
    turtle.up();
  elseif message.act == "down" then
    turtle.down();
  elseif message.act == "dig" then
    turtle.dig();
  elseif message.act == "digUp" then
    turtle.digUp();
  elseif message.act == "digDown" then
    turtle.digDown();
  elseif message.act == "select" then
    turtle.select(message.value);
  elseif message.act == "place" then
    turtle.place();
  elseif message.act == "placeUp" then
    turtle.placeUp();
  elseif message.act == "placeDown" then
    turtle.placeDown();
  elseif message.act == "eval" then
    assert(load(tostring(message.value)))();
  elseif message.act == "refuel" then
    turtle.refuel(64);
  end
end
