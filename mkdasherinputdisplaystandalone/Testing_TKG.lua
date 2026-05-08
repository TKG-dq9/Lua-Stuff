-- GUI text colours
local colours = {
   bg = "#000000b0",
   active = "green",
   inactive = "grey",
   touch = "cyan",
   label = "white",
   outline = "clear"
}

-- The order shown in TASVideos.org
local order = {
   "debug",
   "R",
   "L",
   "X",
   "Y",
   "A",
   "B",
   "start",
   "select",
   "up",
   "down",
   "left",
   "right",
   "lid",
   "x",
   "y",
   "touch"
}

-- Inputs you want held down
local holdInput = {
      B = true,
   left = true
}

local inputs = {}
local screen = {}

local x = 50
local y = -192
local charWidth = 6
local lineHeight = 10

-- There's no "right align" for gui.text so you need to manually do it with a helper function
local function rightAlignText(xRight, y, text, colour, bg)
   local str = tostring(text)
   local width = string.len(str) * charWidth
   gui.text(xRight - width, y, str, colour, bg)
end

local function main()
   --joypad.set(holdInput) -- commented out for now

   inputs = joypad.get()
   screen = stylus.get()

   -- background box
   gui.box(x - 50, y, x + 50, y + 192, colours.bg, colours.bg)

   for i, orderString in ipairs(order) do -- ipairs respects indexing while pairs is somewhat random

      local newY = y + i * lineHeight
      rightAlignText(x, newY, string.upper(orderString) .. ":", colours.label, colours.outline)

      local colour = colours.inactive

      for button, bool in pairs(inputs) do
         if tostring(button) == orderString then
            if bool then
               colour = colours.active
            end

            gui.text(x + charWidth, newY, string.upper(tostring(bool)), colour, colours.outline)
         end
      end

      for t, b in pairs(screen) do

         local screenString = tostring(t)
         if screenString == orderString then

            if screen.touch then
               colour = colours.touch
            end

            if screenString == "touch" then
               gui.text(x + charWidth, newY, string.upper(tostring(b)), colour, colours.outline)
            else
               rightAlignText(x + charWidth * 6, newY, b .. "PX", colour, colours.outline)
            end
         end
      end
   end
end

gui.register(main) -- Used only once
