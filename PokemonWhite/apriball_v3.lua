local items = {
   -- ID, modifier
   {0x01EC, 0x00004000}, -- fast ball x4
   {0x01ED, 0x00001000}, -- level ball x1
   {0x01EE, 0x00004000}, -- lure ball x4
   {0x01EF, 0x00001000}, -- heavy ball x1
   {0x01F0, 0x00008000}, -- love ball x8
   {0x01F1, 0x00001000}, -- friend ball x1
   {0x01F2, 0x00004000}, -- moon ball x4
   {0x01F3, 0x00001800}, -- sport ball x1.5
   {0x01F4, 0x00001000}  -- park ball x1
}

local baseInv = 0x02233FCC
local modifier = nil
local modifierReal = 0x00001000

local function main()
   for i = 0, #items - 1 do
      local ID = baseInv + i * 0x4
      local count = ID + 0x2
      memory.writeword(ID, items[i + 1][1])
      memory.writeword(count, 0x384)
   end

   --gui.text(170, -187, "M0DIFIER: x" .. modifierReal / 0x1000)
end

--gui.register(main)

-- Set item flags to 1 (Balls)
memory.registerexec(0x0220baa0, function()
   local r1 = memory.getregister("r1")
   for i = 1, #items do
      if r1 == items[i][1] then
         memory.setregister("r0", 1)
      end
   end
end)

-- Catch rate (Master Ball)
memory.registerexec(0x021cbae2, function()
   --memory.setregister("r3", 0x0001)
end)

-- Change sprite (Master Ball)
memory.registerexec(0x021f954a, function()
   memory.setregister("r1", 0x021E0001)
end)

-- Set modifier
memory.registerexec(0x021cbc18, function()
   local r3 = memory.getregister("r3")
   for i = 1, #items do
      if r3 == items[i][1] then
         modifier = items[i][2]
      end
   end
end)

-- Overwrite modifier
memory.registerexec(0x021cbc1c, function()
   if modifier then
      memory.setregister("r0", modifier)
   end
   modifierReal = memory.getregister("r0")
end)
