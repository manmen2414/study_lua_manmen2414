local function round(val, decimal)
  local mult = 10 ^ (decimal or 0)
  return math.floor(val * mult + 0.2) / mult
end

---@param codeOrUTF8Char (number|string)[]
---@return [string,string][] utf16Bytes,string utf8Text
local function unicodesToUtf16Byte(codeOrUTF8Char)
  -- Retrieve Unicode code points from UTF-8
  ---@type [string,string][]
  local utf16Bytes = {};
  local utf8Text = "";
  for i, char in ipairs(codeOrUTF8Char) do
    local code = 0;
    if type(char) == "number" then
      code = char;
      utf8Text = utf8Text .. utf8.char(char);
    else
      code = utf8.codepoint(char);
      utf8Text = utf8Text .. char;
    end

    -- Convert to a 2x2 digit sequence in UTF-16 (Big-Endian)
    local firstByte = string.format("%02X", math.floor(code / 256));
    local secondByte = string.format("%02X", code % 256);

    utf16Bytes[i] = { firstByte, secondByte };
  end
  return utf16Bytes, utf8Text;
end

---@param areaWidth number
---@param textWidth number
---@param areaHeight number|nil
---@param textHeight number|nil
---@return number x,number y
local function getCenter(areaWidth, textWidth, areaHeight, textHeight)
  local w = areaWidth / 2 - textWidth / 2;
  local h = 0;
  if areaHeight and textHeight then
    h = areaHeight / 2 - textHeight / 2;
  end
  return w, h;
end

return {
  round = round,
  unicodesToUtf16Byte = unicodesToUtf16Byte,
  getCenter = getCenter
};
