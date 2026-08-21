---@meta

---@alias TomsImageRef string
---@alias ColorObjectSolveable ColorObject|string|number


---@class TomsGPUImpl
local GPUImpl = {
  --- Create a window with a normal GPU context
  --- @param x number
  --- @param y number
  --- @param w number
  --- @param h number
  --- @return table
  createWindow = function(x, y, w, h) end,

  --- Create a window with a 3D GPU context
  --- @param x number
  --- @param y number
  --- @param width number
  --- @param height number
  --- @return table
  createWindow3D = function(x, y, width, height) end,

  --- Draw the window buffer into the parent context or update the monitors on the GPU Peripheral.
  sync = function() end,

  --- The function accepts unpacked numbers or buffer references. Returns the decoded image or throws an error if the image is corrupted or too big
  --- @param ... table
  --- @return TomsImage
  decodeImage = function(...) end,

  --- Returns the currently used VRAM by the GPU
  --- @return number
  getUsedMemory = function() end,

  --- Creates a new image with the defined size
  --- @param width number
  --- @param height number
  --- @return TomsImage
  newImage = function(width, height) end,

  --- Creates a new byte buffer with the given initial size or 32 bytes as the default.
  --- @param initialSize number|nil
  newBuffer = function(initialSize) end,

  --- Creates an image with an unpacked ARGB pixels buffer
  --- @param width number
  --- @param ... number
  --- @return TomsImage
  imageFromBuffer = function(width, ...) end,

  --- Returns the maximum available VRAM
  --- @return number
  getMaxMemory = function() end,

  --- Returns the Window bounds object if the context was created using createWindow
  --- @return table
  getBounds = function() end,

  --- Returns the context size in pixels
  --- @return number
  getSize = function() end,

  --- Draw filled rectangle
  --- @param x number
  --- @param y number
  --- @param width number
  --- @param height number
  --- @param colorRGB number
  filledRectangle = function(x, y, width, height, colorRGB) end,

  --- Draw a rectangle outline
  --- @param x number
  --- @param y number
  --- @param width number
  --- @param height number
  --- @param colorRGB number
  rectangle = function(x, y, width, height, colorRGB) end,

  --- Draw a smooth line between two points
  --- @param x1 number
  --- @param y1 number
  --- @param x2 number
  --- @param y2 number
  --- @param colorRGB number
  lineS = function(x1, y1, x2, y2, colorRGB) end,

  --- @param name string
  setFont = function(name) end,
  --- @return string
  getFont = function() end,
  --- @param x number
  --- @param y number
  --- @param text any
  --- @param textColorRGB number|nil default white
  --- @param bgColorRGB number|nil default black
  --- @param size number|nil default 1
  --- @param padding number|nil
  drawText = function(x, y, text, textColorRGB, bgColorRGB, size, padding) end,
  --- @param x number
  --- @param y number
  --- @param text any
  --- @param textColorRGB number|nil default white
  --- @param bgColorRGB number|nil default black
  --- @param forceUnicode boolean|nil default false
  --- @param size number|nil default 1
  --- @param padding number|nil
  drawTextSmart = function(x, y, text, textColorRGB, bgColorRGB, forceUnicode, size, padding) end,
  --- @return number
  freeChars = function() end,
  --- @param x number
  --- @param y number
  --- @param charID number
  --- @param textColorRGB number|nil default white
  --- @param bgColorRGB number|nil default black
  --- @param size number|nil
  drawChar = function(x, y, charID, textColorRGB, bgColorRGB, size) end,
  clearChars = function() end,
  --- @param charID number
  delChar = function(charID) end,
  --- @param x number
  --- @param y number
  --- @param imageWidth number
  --- @param scale number
  --- @param ... number[] ARGB
  drawBuffer = function(x, y, imageWidth, scale, ...) end,
  --- @param x number
  --- @param y number
  --- @param imageRef TomsImageRef
  drawImage = function(x, y, imageRef) end,
  --- @param char string
  --- @param width number
  --- @param ... table[]
  addNewChar = function(char, width, ...) end,
  --- @param text string
  --- @param size number|nil
  --- @param padding number|nil
  --- @return number
  getTextLength = function(text, size, padding) end,
  getFontDefaultCharID = function() end,
  --- @param charID number
  setFontDefaultCharID = function(charID) end,
  --- Fills the whole window to a single color, color value defaults to black.
  --- @param colorRGB number|nil
  fill = function(colorRGB) end,

  --- Draw a line between two points
  --- @param x1 number
  --- @param y1 number
  --- @param x2 number
  --- @param y2 number
  --- @param colorRGB number
  line = function(x1, y1, x2, y2, colorRGB) end,

}

---@class TomsGPU: TomsGPUImpl
local GPU = {
  --- Detects and reloads all of the connected screens. Recommended to call at the start of the program
  refreshSize = function() end,

  --- Sets the resolution for all of the individual screen blocks
  --- @param resolution number
  setSize = function(resolution) end,

  --- Returns the screen size, in pixels, in blocks and the resolution multiplier
  --- @return number width,number height,number widthBlocks, number heightBlocks,number resolution
  getSize = function() end,

  --- Update all of the screens from the internal buffer.
  sync = function() end,
}

---@class TomsImage
local TomsImage = {
  --- Returns the image width
  --- @return number
  getWidth = function() end,
  --- Returns the image height
  --- @return number
  getHeight = function() end,
  --- Returns the color of the pixel at x and y coordinates
  --- @param x number -1~(imageWidth-2)
  --- @param y number -1~(imageHeight-2)
  --- @return number
  getRGB = function(x, y) end,
  --- Saves the image into a ByteBuffer. Returns the ByteBuffer
  --- @return table
  saveImage = function() end,
  --- Returns the image pixels as an unpacked ARGB numbers
  --- @return ...number
  getAsBuffer = function() end,
  --- Set the color value of the pixel at x and y
  --- @param x number -1~(imageWidth-2)
  --- @param y number -1~(imageHeight-2)
  --- @param color number
  setRGB = function(x, y, color) end,
  --- Returns a GPU context where output is drawn onto this image.
  --- @return TomsGPUImpl
  gpuDraw = function() end,
  --- Removes the image from the used VRAM amount and marks the image invalid.
  --- @return number
  free = function() end,
  --- Returns a string reference to the image.The reference is only usable on the same peripheral.
  --- @return TomsImageRef
  ref = function() end,
}

---@class TextComponent
local TextComponent = {
  ---@type string
  text = "",
  ---@type number|nil
  size = nil,
  ---@type ColorObjectSolveable|nil
  color = nil,
  ---@type ColorObjectSolveable|nil
  bgColor = nil,
}
