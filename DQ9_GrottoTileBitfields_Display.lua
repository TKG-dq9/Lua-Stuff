local baseAddr = 0x02312794 -- 0x02312794 = tile type, 0x02312694 = floorMap
local walkMap = {}

local fill = {
   ["0"] = "white",    -- room
   ["1"] = "black",    -- wall
   ["2"] = "white",    -- path
   ["3"] = "black",    -- divider
   ["4"] = "red",    -- stairs (up)
   ["5"] = "green",    -- stairs (down)
   ["6"] = "blue",    -- chest
   ["8"] = "white",    -- node
   ["FF"] = "black"     -- wall
}

local text = {
   ["0"] = "grey",    -- room
   ["1"] = "grey",    -- wall
   ["2"] = "grey",    -- path
   ["3"] = "grey",    -- divider
   ["4"] = "grey",    -- stairs (up)
   ["5"] = "grey",    -- stairs (down)
   ["6"] = "grey",    -- chest
   ["8"] = "grey",    -- node
   ["FF"] = "grey"     -- wall
}

local function getHex(num, digits)
    return string.format("%0"..digits.."X", num)
end

local function getTileType()
   for i = 0, 255 do
      --memory.writebyte(baseAddr + i, 0x0)
      walkMap[i + 1] = getHex(memory.readbyte(baseAddr + i), 2)
   end
end

local function getFillColour(tileType)
   for k, v in pairs(fill) do
      if tileType == k then return v end
   end
   return "white"
end

local function getTextColour(tileType)
   for k, v in pairs(text) do
      if tileType == k then return v end
   end
   return "black"
end

local function renderGui()
   for y = 0, 15 do
      for x = 0, 15 do
         local index = walkMap[y * 16 + x + 1]
         local x1 = x * 14
         local y1 = y * 12
         local x2 = x1 + 14
         local y2 = y1 + 12
         gui.box(x1, y1, x2, y2, getFillColour(index),"grey")
         gui.text(x1 + 2, y1 + 3, index, getTextColour(index), "clear")
      end
   end
end

local function main()
   getTileType()
   renderGui()
end

gui.register(main)
