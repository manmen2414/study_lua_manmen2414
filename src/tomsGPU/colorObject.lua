local util = require("tomsGPU.util");

---@param color string
---@return number|nil,number,number
local function paletteToRGB(color)
  if not colors[color] then
    return nil, 0, 0;
  end
  local colorValue = colors[color:lower()];
  local r, g, b = term.getPaletteColor(colorValue);
  return util.round(r * 255), util.round(g * 255), util.round(b * 255)
end

---@param a1 ColorObjectSolveable red value, rgb string or number, argb string or number, palette color string
---@param green number|nil
---@param blue number|nil
---@param alpha number|nil
local function colorObject(a1, green, blue, alpha)
  if type(a1) == "table" then
    -- return for ColorObject
    return a1;
  end
  if green == nil and type(a1) == "number" then
    -- format for number
    a1 = string.format("%06x", a1);
  end
  if type(a1) == "string" then
    local paletteR, paletteG, paletteB = paletteToRGB(a1);
    if paletteR then
      -- return for palette color string
      return colorObject(paletteR, paletteG, paletteB);
    end
    -- format
    if a1:sub(1, 1) == "#" then
      a1 = a1:sub(2);
    end
    a1 = ("0"):rep(6 - #a1) .. a1;
    if #a1 == 6 then
      a1 = "ff" .. a1;
    end
    a1 = ("0"):rep(8 - #a1) .. a1;

    alpha = tonumber(a1:sub(1, 2), 16);
    green = tonumber(a1:sub(5, 6), 16);
    blue = tonumber(a1:sub(7, 8), 16);

    a1 = tonumber(a1:sub(3, 4), 16);
  end

  alpha = alpha or 0xff;
  local rgbNum = a1 * 0x10000 + green * 0x100 + blue;
  local rgb = string.format("%06x", rgbNum);
  local rawA = string.format("%02x", alpha);
  ---@class ColorObject
  local cObject = {
    r = a1,
    rawR = string.format("%x", a1),
    g = green,
    rawG = string.format("%x", green),
    b = blue,
    rawB = string.format("%x", blue),
    a = alpha,
    rawA = string.format("%x", alpha),
    RGB = rgb,
    RGBA = rgb .. rawA,
    ARGB = rawA .. rgb,
    num = rgbNum
  }

  ---@param bColor ColorObjectSolveable
  ---@return ColorObject
  function cObject.getMixedToOpaqueColor(bColor)
    local a = cObject.a / 255;
    local bg = colorObject(bColor)
    local rOut = util.round(cObject.r * a + bg.r * (1 - a));
    local gOut = util.round(cObject.g * a + bg.g * (1 - a));
    local bOut = util.round(cObject.b * a + bg.b * (1 - a));
    return colorObject(rOut, gOut, bOut);
  end

  return cObject;
end
return {
  colorObject = colorObject,
  c = colorObject
}
