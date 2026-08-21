local toms = require("tomsGPU");
local linkRes = peripheral.wrap("left");

local gpu = toms.gpuExtend(peripheral.wrap("right"));

gpu.init("#000000", "#ffffff", 64)
gpu.drawRectangle(10, 10, 60, 20, "blue");
gpu.drawTextComponent(10, 12, { { text = "MA100", bgColor = "blue", size = 1 } }, 60);

gpu.sync();
