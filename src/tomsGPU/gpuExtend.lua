local imageExtend = require("tomsGPU.imageExtend");
local util = require("tomsGPU.util");
local charSizeOVRDs = require("tomsGPU.charSizeOVRD").charSizeOVRDs;
local c = require("tomsGPU.colorObject").colorObject;

---@param gpuImpl TomsGPUImpl
---@return GPUImplExtend
local function gpuImplExtend(gpuImpl)
  ---@class GPUImplExtend:TomsGPUImpl
  local impl = {
    backgroundColor = c(0, 0, 0),
    foregroundColor = c(255, 255, 255)
  }

  ---@param x number If the value is -1, only the length to be used will be retrieved without writing anything.
  ---@param y number
  ---@param char string|number utf-8 char or charcode
  ---@param size number|nil
  ---@param fColor ColorObjectSolveable|nil
  ---@param bColor ColorObjectSolveable|nil
  ---@return number usedLength,boolean successed
  function impl.drawUnicodeChar(x, y, char, size, fColor, bColor)
    fColor = fColor or impl.foregroundColor;
    bColor = bColor or impl.backgroundColor;
    size = size or 1;

    local bytes, textStr = util.unicodesToUtf16Byte({ char });
    local firstByte = bytes[1][1];
    local secondByte = bytes[1][2];
    local charStr = textStr:sub(1, 1);

    local writeByte = tonumber(secondByte, 16) + 1;
    local successed = true;

    -- Set the font to one that contains the relevant character, and then draw the character
    impl.setFont("unicode_page_" .. firstByte:lower());
    if x ~= -1 then
      local fg = c(fColor).getMixedToOpaqueColor(bColor);
      successed = pcall(impl.drawChar, x, y, writeByte, fg.num, c(bColor).num, size);
    end

    -- The exact font size cannot be obtained (this is probably a bug)
    if charSizeOVRDs[charStr] then
      return charSizeOVRDs[charStr], successed;
    end
    return impl.getTextLength("_", size), successed;
  end

  ---@param x number If the value is -1, only the length to be used will be retrieved without writing anything.
  ---@param y number
  ---@param text string
  ---@param size number|nil
  ---@param fColor ColorObjectSolveable|nil
  ---@param bColor ColorObjectSolveable|nil
  ---@return number usedLength,boolean successed
  function impl.drawUnicodeStr(x, y, text, size, fColor, bColor)
    -- Split a string containing UTF-8 encoding into individual code points
    local writtenWidth = 0;
    local drawSuccessed = true;
    local codes = { utf8.codepoint(text, 1, #text) };
    for i = 1, #codes, 1 do
      local writeX = x;
      if x ~= -1 then
        writeX = writeX + writtenWidth;
      end
      local resultSize, successed = impl.drawUnicodeChar(writeX, y, codes[i], size, fColor, bColor);
      writtenWidth = writtenWidth + resultSize;

      if not successed then
        drawSuccessed = false;
        break;
      end
    end
    return writtenWidth, drawSuccessed;
  end

  ---@param x number If the value is -1, only the length to be used will be retrieved without writing anything.
  ---@param y number
  ---@param textComponent TextComponent[]
  ---@param widthForCenter number|nil If a value is given, center the text.
  ---@return number usedLength,boolean successed
  function impl.drawTextComponent(x, y, textComponent, widthForCenter)
    if widthForCenter and x ~= 0 then
      local useWidth = impl.drawTextComponent(-1, 0, textComponent);
      x = x + util.getCenter(widthForCenter, useWidth);
    end
    local writtenWidth = 0;
    local drawSuccessed = true;
    for _, v in ipairs(textComponent) do
      local resultSize, successed = impl.drawUnicodeStr(x + writtenWidth, y, v.text, v.size, v.color, v.bgColor)
      writtenWidth = writtenWidth + resultSize;

      if not successed then
        drawSuccessed = false;
        break;
      end
    end

    return writtenWidth, drawSuccessed;
  end

  ---@param path string
  function impl.readImage(path)
    local of = io.open(path, "rb")
    if not of then
      error("cannot open " .. path);
    end
    --- 魔法のコード (https://github.com/tom5454/Toms-Peripherals/blob/api/examples/cc_term_font.lua より)
    local b = of._handle.read(1)
    local imgBin = {}
    while b do
      imgBin[#imgBin + 1] = ("<I1"):unpack(b);
      b = of._handle.read(1)
    end
    local image = imageExtend.imageExtend(impl.decodeImage(table.unpack(imgBin)));

    return image;
  end

  ---@param image ImageExtend
  function impl.cloneImage(image)
    return imageExtend.imageExtend(impl.imageFromBuffer(image.getWidth(), image.getAsBuffer()));
  end

  ---@param x number
  ---@param y number
  ---@param image ImageExtend
  ---@param bColor ColorObjectSolveable|nil
  ---@return boolean successed
  function impl.drawImageExtend(x, y, image, bColor)
    bColor = bColor or impl.backgroundColor;
    local cloned = impl.cloneImage(image);
    cloned.fillImageBG(bColor);
    local successed = pcall(impl.drawImage, x, y, cloned.ref());
    return successed;
  end

  ---@param path string
  ---@param x number
  ---@param y number
  ---@param bColor ColorObjectSolveable|nil
  ---@return boolean successed
  function impl.drawImageFromPath(x, y, path, bColor)
    return impl.drawImageExtend(x, y, impl.readImage(path), bColor)
  end

  ---@param sync boolean|nil
  function impl.clear(sync)
    impl.fill(impl.backgroundColor.num);
    if sync then
      impl.sync();
    end
  end

  ---@param bColor ColorObjectSolveable|nil
  ---@param fColor ColorObjectSolveable|nil
  function impl.init(bColor, fColor)
    impl.backgroundColor = c(bColor or impl.backgroundColor);
    impl.foregroundColor = c(fColor or impl.foregroundColor);
    impl.clear();
  end

  ---@param x number
  ---@param y number
  ---@param width number
  ---@param height number
  ---@param bgColor ColorObjectSolveable|nil
  ---@param lineColor ColorObjectSolveable|nil
  ---@param lineSize number|nil
  ---@return boolean successed
  function impl.drawRectangle(x, y, width, height, bgColor, lineColor, lineSize)
    bgColor = bgColor or impl.backgroundColor;
    lineColor = lineColor or bgColor;
    lineSize = lineSize or 0;

    bgColor = c(bgColor);
    lineColor = c(lineColor);

    if lineSize > 0 then
      local successed = pcall(impl.filledRectangle, x, y, width, height, lineColor.num);
      if not successed then
        return false;
      end
    end

    local successed = pcall(impl.filledRectangle, x + lineSize, y + lineSize, width - lineSize * 2, height - lineSize * 2,
      bgColor.num);
    return successed;
  end

  setmetatable(impl, { __index = gpuImpl });

  return impl;
end

---@param gpu TomsGPU
---@return GPUExtend
local function gpuExtend(gpu)
  ---@class GPUExtend:TomsGPU,GPUImplExtend
  local newGPU = gpuImplExtend(gpu);
  setmetatable(newGPU, { __index = gpu });

  ---@param bColor ColorObjectSolveable|nil
  ---@param fColor ColorObjectSolveable|nil
  ---@param resolution number|nil
  function newGPU.init(bColor, fColor, resolution)
    newGPU.refreshSize();
    if resolution then
      newGPU.setSize(resolution);
    end
    newGPU.backgroundColor = c(bColor or newGPU.backgroundColor);
    newGPU.foregroundColor = c(fColor or newGPU.foregroundColor);
    sleep(0.05);
    newGPU.clear(true);
  end

  return newGPU;
end

return {
  gpuImplExtend = gpuImplExtend,
  gpuExtend = gpuExtend
}
