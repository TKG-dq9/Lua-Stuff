local apriballIDs = {
   0x01EC, -- fast ball
   0x01ED, -- level ball
   0x01EE, -- lure ball
   0x01EF, -- heavy ball
   0x01F0, -- love ball
   0x01F1, -- friend ball
   0x01F2, -- moon ball
   0x01F3, -- sport ball
   0x01F4  -- park ball
}

local baseInv = 0x02233FCC

local function overwriteBalls()
   for i = 0, #apriballIDs - 1 do
      local id = baseInv + i * 0x4
      local count = id + 0x2
      memory.writeword(id, apriballIDs[i + 1])
      memory.writeword(count, 0x384)
   end
end

gui.register(overwriteBalls)

memory.registerexec(0x0220baa0, function()
   local r1 = memory.getregister("r1")
   for i = 1, #apriballIDs do
      if r1 == apriballIDs[i] then
         memory.setregister("r0", 1)
      end
   end
end)
