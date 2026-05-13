local addr = {
   baseInv = 0x02233FCC,
   baseTask = 0x022598DC, -- Fishing: offset +0xC = 6?
   
   -- Player
   pSpecies = 0x022A7E88,
   pLevel = 0x022BE0F0,
   pGender = 0x022BE0F1,

   -- Opponent
   oSpecies = 0x022A7E2C,
   oLevel = 0x022BE170,
   oGender = 0x022BE171
}

local items = {
   -- ID, modifier
   {0x01EC, 0x00004000}, -- Fast Ball
   {0x01ED, 0x00001000}, -- Level Ball
   {0x01EE, 0x00003000}, -- Lure Ball
   {0x01EF, 0x00001000}, -- Heavy Ball
   {0x01F0, 0x00008000}, -- Love Ball
   {0x01F1, 0x00001000}, -- Friend Ball
   {0x01F2, 0x00004000}, -- Moon Ball
   {0x01F3, 0x00001800}, -- Sport Ball
   {0x01F4, 0x00001000}, -- Park Ball
   {0x0005, 0x00001800}  -- Safari Ball
}

local speed = {
   0x0006, -- Base Speed: 100 (Charizard)
   0x0016, -- Base Speed: 100 (Fearow)
   0x001A, -- Base Speed: 100 (Raichu)
   0x0026, -- Base Speed: 100 (Ninetales)
   0x0049, -- Base Speed: 100 (Tentacruel)
   0x0055, -- Base Speed: 100 (Dodrio)
   0x0064, -- Base Speed: 100 (Voltorb)
   0x0091, -- Base Speed: 100 (Zapdos)
   0x0097, -- Base Speed: 100 (Mew)
   0x009D, -- Base Speed: 100 (Typhlosion)
   0x00F1, -- Base Speed: 100 (Miltank)
   0x00F4, -- Base Speed: 100 (Entei)
   0x00FB, -- Base Speed: 100 (Celebi)
   0x0108, -- Base Speed: 100 (Linoone)
   0x0121, -- Base Speed: 100 (Slaking)
   0x014A, -- Base Speed: 100 (Flygon)
   0x0175, -- Base Speed: 100 (Salamence)
   0x0181, -- Base Speed: 100 (Jirachi)
   0x018E, -- Base Speed: 100 (Staraptor)
   0x01E4, -- Base Speed: 100 (Palkia)
   0x01E6, -- Base Speed: 100 (Regigigas)
   0x01EA, -- Base Speed: 100 (Manaphy)
   0x01EC, -- Base Speed: 100 (Shaymin (Land Forme))
   0x01EE, -- Base Speed: 100 (Victini)
   0x027D, -- Base Speed: 100 (Volcarona)
   0x0200, -- Base Speed: 101 (Simisage)
   0x0202, -- Base Speed: 101 (Simisear)
   0x0204, -- Base Speed: 101 (Simipour)
   0x0285, -- Base Speed: 101 (Landorus (Incarnate Forme))
   0x01BD, -- Base Speed: 102 (Garchomp)
   0x024B, -- Base Speed: 103 (Emolga)
   0x0040, -- Base Speed: 105 (Kadabra)
   0x004E, -- Base Speed: 105 (Rapidash)
   0x007B, -- Base Speed: 105 (Scyther)
   0x007D, -- Base Speed: 105 (Electabuzz)
   0x0136, -- Base Speed: 105 (Manectric)
   0x01AC, -- Base Speed: 105 (Lopunny)
   0x01AD, -- Base Speed: 105 (Mismagius)
   0x023B, -- Base Speed: 105 (Zoroark)
   0x0267, -- Base Speed: 105 (Cryogonal)
   0x026C, -- Base Speed: 105 (Mienshao)
   0x01FE, -- Base Speed: 106 (Liepard)
   0x0188, -- Base Speed: 108 (Infernape)
   0x0254, -- Base Speed: 108 (Galvantula)
   0x027E, -- Base Speed: 108 (Cobalion)
   0x027F, -- Base Speed: 108 (Terrakion)
   0x0280, -- Base Speed: 108 (Virizion)
   0x0287, -- Base Speed: 108 (Keldeo)
   0x0278, -- Base Speed: 109 (Durant)
   0x005E, -- Base Speed: 110 (Gengar)
   0x0080, -- Base Speed: 110 (Tauros)
   0x00BD, -- Base Speed: 110 (Jumpluff)
   0x00C4, -- Base Speed: 110 (Espeon)
   0x00F9, -- Base Speed: 110 (Lugia)
   0x017C, -- Base Speed: 110 (Latias)
   0x017D, -- Base Speed: 110 (Latios)
   0x01DE, -- Base Speed: 110 (Froslass)
   0x0237, -- Base Speed: 110 (Archeops)
   0x0281, -- Base Speed: 111 (Tornadus (Incarnate Forme))
   0x0282, -- Base Speed: 111 (Thundurus (Incarnate Forme))
   0x01B0, -- Base Speed: 112 (Purugly)
   0x0221, -- Base Speed: 112 (Scolipede)
   0x01F1, -- Base Speed: 113 (Serperior)
   0x0210, -- Base Speed: 114 (Swoobat)
   0x0035, -- Base Speed: 115 (Persian)
   0x0079, -- Base Speed: 115 (Starmie)
   0x00D7, -- Base Speed: 115 (Sneasel)
   0x00F3, -- Base Speed: 115 (Raikou)
   0x01A3, -- Base Speed: 115 (Floatzel)
   0x01A8, -- Base Speed: 115 (Ambipom)
   0x01E2, -- Base Speed: 115 (Azelf)
   0x023D, -- Base Speed: 115 (Cinccino)
   0x020B, -- Base Speed: 116 (Zebstrika)
   0x0223, -- Base Speed: 116 (Whimsicott)
   0x0033, -- Base Speed: 120 (Dugtrio)
   0x0041, -- Base Speed: 120 (Alakazam)
   0x00FE, -- Base Speed: 120 (Sceptile)
   0x01ED, -- Base Speed: 120 (Arceus)
   0x0115, -- Base Speed: 125 (Swellow)
   0x01CD, -- Base Speed: 125 (Weavile)
   0x01EB, -- Base Speed: 125 (Darkrai)
   0x01EC, -- Base Speed: 127 (Shaymin (Sky Forme))
   0x0288, -- Base Speed: 128 (Meloetta (Pirouette Forme))
   0x0087, -- Base Speed: 130 (Jolteon)
   0x008E, -- Base Speed: 130 (Aerodactyl)
   0x0096, -- Base Speed: 130 (Mewtwo)
   0x00A9, -- Base Speed: 130 (Crobat)
   0x0065, -- Base Speed: 140 (Electrode)
   0x0269, -- Base Speed: 145 (Accelgor)
   0x0182, -- Base Speed: 150 (Deoxys (Normal Forme))
   0x0182, -- Base Speed: 150 (Deoxys (Attack Forme))
   0x0123, -- Base Speed: 160 (Ninjask)
   0x0182  -- Base Speed: 180 (Deoxys (Speed Forme))
}

local blockA = {
   1, 1, 1, 1, 1, 1,
   2, 2, 3, 4, 3, 4,
   2, 2, 3, 4, 3, 4,
   2, 2, 3, 4, 3, 4
}

local moonStone = {
   0x001D, -- 0029 Nidoran (Female)
   0x001E, -- 0030 Nidorina
   0x001F, -- 0031 Nidoqueen
   0x0020, -- 0032 Nidoran (Male)
   0x0021, -- 0033 Nidorino
   0x0022, -- 0034 Nidoking
   0x00AD, -- 0173 Cleffa
   0x0023, -- 0035 Clefairy
   0x0024, -- 0036 Clefable
   0x00AE, -- 0174 Igglybuff
   0x0027, -- 0039 Jigglypuff
   0x0028, -- 0040 Wigglytuff
   0x012C, -- 0300 Skitty
   0x012D, -- 0301 Delcatty
   0x0205, -- 0517 Munna
   0x0206, -- 0518 Musharna
}

local modifier = nil
local modifierReal = 0x00001000
local modifierDefault = 0x00001000
local seed
local mult = 0x41C64E6D
local inc = 0x6073
local friendBallFlag = false
local addToParty = false
local slotParty = nil
local slotPC = nil

local function getHex(decimal, digits)
   return string.format("%0"..digits.."X", decimal)
end

local function prng()
   local hi = bit.rshift(seed, 16)
   local lo = (bit.band(seed, 65535)) * mult + inc
   local cr = bit.rshift(lo, 16)
   lo = bit.band(lo, 65535)
   hi = bit.band(hi * mult + cr, 65535)
   seed = bit.bor(bit.lshift(hi, 16), lo)
   return seed
end

local function fastBall()
   local oppSpecies = memory.readword(addr.oSpecies)
   for i = 1, #speed do
      if oppSpecies == speed[i] then
         return items[1][2]
      end
   end
   return modifierDefault
end

local function levelBall()
   local pLv = memory.readbyte(addr.pLevel)
   local oLv = memory.readbyte(addr.oLevel)

   if pLv <= oLv then
      return modifierDefault
   elseif pLv > oLv and pLv < oLv * 2 then
      return modifierDefault * 2
   elseif pLv >= oLv * 2 and pLv < oLv * 4 then
      return modifierDefault * 4
   else
      return modifierDefault * 8
   end
end

local function lureBall()
   local fishing = memory.readdword(addr.baseTask + 0xC) -- 0x021aa25e str r0,[r4,#0xc]  
   if fishing == 6 then
      return items[3][2]
   end
   return modifierDefault
end

local function loveBall()
   local playerSpecies = memory.readword(addr.pSpecies)
   local playerGender = memory.readbyte(addr.pGender)
   local oppSpecies = memory.readword(addr.oSpecies)
   local oppGender = memory.readbyte(addr.oGender)

   if playerGender > 1 or oppGender > 1 then
      return modifierDefault
   end

   if playerSpecies == oppSpecies and playerGender ~= oppGender then
      return items[5][2]
   end

   return modifierDefault
end

local function friendBall(base)
   local decrypted = {}
   local pid = memory.readdword(base + 0x0)
   local shift = bit.rshift(bit.band(pid, 0x3E000), 0xD) % 24
   local offset = (blockA[shift + 1] - 1) * 0x20 + 0x14
   local checksum = memory.readword(base + 0x6)
   
   seed = checksum
   for i = 0, 63 do
      seed = prng()
      local key = bit.rshift(seed, 16)
      local encrypted = memory.readword(base + i * 2 + 0x8)
      decrypted[i + 1] = bit.bxor(encrypted, key)
   end

   decrypted[7] = bit.bor(bit.band(decrypted[7], 0xFF00), 200)

   checksum = 0
   for i = 0, 63 do
      checksum = bit.band(checksum + decrypted[i + 1], 0xFFFF)
   end

   memory.writeword(base + 0x6, checksum)

   seed = checksum
   for i = 0, 63 do
      seed = prng()
      local key = bit.rshift(seed, 16)
      local encrypted = bit.bxor(decrypted[i + 1], key)
      memory.writeword(base + i * 2 + 0x8, encrypted)
   end
end

local function moonBall()
   local oppSpecies = memory.readword(addr.oSpecies)
   for i = 1, #moonStone do
      if oppSpecies == moonStone[i] then
         return items[7][2]
      end
   end
   return modifierDefault
end

local function main()
   -- Overwrite inventory with cut pokeballs x900
   for i = 0, #items - 1 do
      local ID = addr.baseInv + i * 0x4
      local count = ID + 0x2
      --memory.writeword(ID, items[i + 1][1])
      --memory.writeword(count, 0x384)
   end

   --gui.text(170, -187, "M0DIFIER: x" .. modifierReal / 0x1000)

end

--gui.register(main)

-- Set item category flag to 1 (Balls)
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

-- Change throw/shake sprites (Poke Ball)
memory.registerexec(0x021f954a, function()
   memory.setregister("r1", 0x021E0004)
end)

-- Set modifier
memory.registerexec(0x021cbc18, function()
   local r3 = memory.getregister("r3")

   modifier = nil
   friendBallFlag = false

   -- Fast Ball
   if r3 == items[1][1] then
      modifier = fastBall()
   end

   -- Level Ball
   if r3 == items[2][1] then
      modifier = levelBall()
   end

   -- Lure Ball     
   if r3 == items[3][1] then
      modifier = lureBall()
   end

   -- Heavy Ball
   if r3 == items[4][1] then
      modifier = items[4][2]
   end

   -- Love Ball (x8 if same species and opposite gender, x1 otherwise)
   if r3 == items[5][1] then
      modifier = loveBall()
   end

   -- Friend Ball (Always x1)
   if r3 == items[6][1] then
      modifier = modifierDefault
      friendBallFlag = true
   end

   -- Moon Ball (x4 if pokemon evolves with moon stone, x1 otherwise)
   if r3 == items[7][1] then
      modifier = moonBall()
   end

   -- Sport Ball (Always x1.5)
   if r3 == items[8][1] then
      modifier = items[8][2]
   end

   -- Park Ball (Always x1)
   if r3 == items[9][1] then
      modifier = modifierDefault
   end

   -- Safari Ball (Always x1.5)
   if r3 == items[10][1] then
      modifier = items[10][2]
   end
end)

-- Overwrite modifier
memory.registerexec(0x021cbc1c, function()
   if modifier then
      memory.setregister("r0", modifier)
   end
   modifierReal = memory.getregister("r0")
end)

-- Reset friendBallFlag if capture fails (flag 0)
memory.registerexec(0x021cbd02, function()
   friendBallFlag = false
end)

-- Empty party slot = true
memory.registerexec(0x021b98da, function()
   local lr = memory.getregister("r14")
   if lr == 0x02019A81 then
      addToParty = true
   end
end)

-- Get empty party slot base
memory.registerexec(0x0201A9B2, function()
   if friendBallFlag and addToParty then
      local r1 = memory.getregister("r1") -- slot index
      local r4 = memory.getregister("r4") -- party base
      slotParty = r4 + r1 * 0xDC + 0x8
   end
end)

-- Overwrite party slot's friendship
memory.registerexec(0x021b98de, function()
   if friendBallFlag and addToParty and slotParty then
      friendBall(slotParty)
      friendBallFlag = false
      addToParty = false
      slotParty = nil
   end
end)

-- Get PC slot base (current box)
memory.registerexec(0x0200757e, function()
   if friendBallFlag then
      local r0 = memory.getregister("r0")
      local r7 = memory.getregister("r7")
      slotPC = r0 + r7
   end
end)

-- Overwrite PC slot's friendship
memory.registerexec(0x0200758c, function()
   if friendBallFlag and slotPC then
      friendBall(slotPC)
      friendBallFlag = false
      slotPC = nil
   end
end)
