local c = require("tomsGPU.colorObject").colorObject;

---@param baseImage TomsImage
---@return ImageExtend
local function imageExtend(baseImage)
  ---@class ImageExtend:TomsImage
  local image = {};

  ---@param x number
  ---@param y number
  function image.getPixel(x, y)
    --- 誰がどう考えてもこのコードは+1ではなく-1すべき↓\
    --- https://github.com/tom5454/Toms-Peripherals/blob/api/src/shared/java/com/tom/peripherals/gpu/LuaImage.java#L116
    local data = string.format("%x", math.abs(image.getRGB(x - 2, y - 2)) - 1);

    if #data > 8 then
      return c(0, 0, 0, 0)
    end

    return c(data)
  end

  ---@param x number
  ---@param y number
  ---@param color ColorObjectSolveable
  function image.pixel(x, y, color)
    --- 誰がどう考えてもこのコードは+1ではなく-1すべき↓\
    --- https://github.com/tom5454/Toms-Peripherals/blob/api/src/shared/java/com/tom/peripherals/gpu/LuaImage.java#L116
    return image.setRGB(x - 2, y - 2, c(color).num)
  end

  ---@param bgColor ColorObjectSolveable
  function image.fillImageBG(bgColor)
    local width = image.getWidth();
    local height = image.getHeight();
    for x = 1, width, 1 do
      for y = 1, height, 1 do
        local pixel = image.getPixel(x, y);
        if pixel.a == 0 then
          image.pixel(x, y, bgColor)
        elseif pixel.a < 255 then
          local brendColor = pixel.getMixedToOpaqueColor(bgColor);
          image.pixel(x, y, brendColor)
        end
      end
    end
    return image;
  end

  setmetatable(image, { __index = baseImage });

  return image;
end

return {
  imageExtend = imageExtend
}
