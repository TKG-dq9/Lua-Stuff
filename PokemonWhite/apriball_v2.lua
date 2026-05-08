local itemIDs = {
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
   for i = 0, #itemIDs - 1 do
      local ID = baseInv + i * 0x4
      local count = ID + 0x2
      memory.writeword(ID, itemIDs[i + 1])
      memory.writeword(count, 0x384)
   end
end

gui.register(overwriteBalls)

-- Set item flags to 1 (Balls)
memory.registerexec(0x0220baa0, function()
   local r1 = memory.getregister("r1")
   for i = 1, #itemIDs do
      if r1 == itemIDs[i] then
         memory.setregister("r0", 1)
      end
   end
end)

-- Master Ball modifier
memory.registerexec(0x021cbae2, function()
   memory.setregister("r3", 1)
end)

-- Change sprite to Poké Ball
memory.registerexec(0x021f954a, function()
   memory.setregister("r1", 0x021E0004)
end)
