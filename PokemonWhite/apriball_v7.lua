local addr = {
   baseInv = 0x02233FCC,
   baseTask = 0x022598DC, -- Fishing: offset +0xC = 6?
   baseWild = 0x0226AD14,
   
   -- Player
   pSpecies = 0x022A7E88,
   pLevel = 0x022BE0F0,
   pGender = 0x022BE0F1,

   -- Opponent
   oSpecies = 0x022A7E2C,
   oLevel = 0x022BE170,
   oGender = 0x022BE171,
   oWeight = 0x022A7E38
}

local items = {
   {0x01EC, "Fast Ball"},
   {0x01ED, "Level Ball"},
   {0x01EE, "Lure Ball"},
   {0x01EF, "Heavy Ball"},
   {0x01F0, "Love Ball"},
   {0x01F1, "Friend Ball"},
   {0x01F2, "Moon Ball"},
   {0x01F3, "Sport Ball"},
   {0x01F4, "Park Ball"},
   {0x0005, "Safari Ball"}
}

local speed = {
   {0x0006, 100}, -- Charizard
   {0x0016, 100}, -- Fearow
   {0x001A, 100}, -- Raichu
   {0x0026, 100}, -- Ninetales
   {0x0049, 100}, -- Tentacruel
   {0x0055, 100}, -- Dodrio
   {0x0064, 100}, -- Voltorb
   {0x0091, 100}, -- Zapdos
   {0x0097, 100}, -- Mew
   {0x009D, 100}, -- Typhlosion
   {0x00F1, 100}, -- Miltank
   {0x00F4, 100}, -- Entei
   {0x00FB, 100}, -- Celebi
   {0x0108, 100}, -- Linoone
   {0x0121, 100}, -- Slaking
   {0x014A, 100}, -- Flygon
   {0x0175, 100}, -- Salamence
   {0x0181, 100}, -- Jirachi
   {0x018E, 100}, -- Staraptor
   {0x01E4, 100}, -- Palkia
   {0x01E6, 100}, -- Regigigas
   {0x01EA, 100}, -- Manaphy
   {0x01EC, 100}, -- Shaymin (Land Forme)
   {0x01EE, 100}, -- Victini
   {0x027D, 100}, -- Volcarona
   {0x0200, 101}, -- Simisage
   {0x0202, 101}, -- Simisear
   {0x0204, 101}, -- Simipour
   {0x0285, 101}, -- Landorus (Incarnate Forme)
   {0x01BD, 102}, -- Garchomp
   {0x024B, 103}, -- Emolga
   {0x0040, 105}, -- Kadabra
   {0x004E, 105}, -- Rapidash
   {0x007B, 105}, -- Scyther
   {0x007D, 105}, -- Electabuzz
   {0x0136, 105}, -- Manectric
   {0x01AC, 105}, -- Lopunny
   {0x01AD, 105}, -- Mismagius
   {0x023B, 105}, -- Zoroark
   {0x0267, 105}, -- Cryogonal
   {0x026C, 105}, -- Mienshao
   {0x01FE, 106}, -- Liepard
   {0x0188, 108}, -- Infernape
   {0x0254, 108}, -- Galvantula
   {0x027E, 108}, -- Cobalion
   {0x027F, 108}, -- Terrakion
   {0x0280, 108}, -- Virizion
   {0x0287, 108}, -- Keldeo
   {0x0278, 109}, -- Durant
   {0x005E, 110}, -- Gengar
   {0x0080, 110}, -- Tauros
   {0x00BD, 110}, -- Jumpluff
   {0x00C4, 110}, -- Espeon
   {0x00F9, 110}, -- Lugia
   {0x017C, 110}, -- Latias
   {0x017D, 110}, -- Latios
   {0x01DE, 110}, -- Froslass
   {0x0237, 110}, -- Archeops
   {0x0281, 111}, -- Tornadus (Incarnate Forme)
   {0x0282, 111}, -- Thundurus (Incarnate Forme)
   {0x01B0, 112}, -- Purugly
   {0x0221, 112}, -- Scolipede
   {0x01F1, 113}, -- Serperior
   {0x0210, 114}, -- Swoobat
   {0x0035, 115}, -- Persian
   {0x0079, 115}, -- Starmie
   {0x00D7, 115}, -- Sneasel
   {0x00F3, 115}, -- Raikou
   {0x01A3, 115}, -- Floatzel
   {0x01A8, 115}, -- Ambipom
   {0x01E2, 115}, -- Azelf
   {0x023D, 115}, -- Cinccino
   {0x020B, 116}, -- Zebstrika
   {0x0223, 116}, -- Whimsicott
   {0x0033, 120}, -- Dugtrio
   {0x0041, 120}, -- Alakazam
   {0x00FE, 120}, -- Sceptile
   {0x01ED, 120}, -- Arceus
   {0x0115, 125}, -- Swellow
   {0x01CD, 125}, -- Weavile
   {0x01EB, 125}, -- Darkrai
   {0x01EC, 127}, -- Shaymin (Sky Forme)
   {0x0288, 128}, -- Meloetta (Pirouette Forme)
   {0x0087, 130}, -- Jolteon
   {0x008E, 130}, -- Aerodactyl
   {0x0096, 130}, -- Mewtwo
   {0x00A9, 130}, -- Crobat
   {0x0065, 140}, -- Electrode
   {0x0269, 145}, -- Accelgor
   {0x0182, 150}, -- Deoxys (Normal Forme)
   {0x0182, 150}, -- Deoxys (Attack Forme)
   {0x0123, 160}, -- Ninjask
   {0x0182, 180}  -- Deoxys (Speed Forme)
}

local genders = {"male", "female", "genderless"}

local blockA = {
   1, 1, 1, 1, 1, 1,
   2, 2, 3, 4, 3, 4,
   2, 2, 3, 4, 3, 4,
   2, 2, 3, 4, 3, 4
}

local blockB = {
   2, 2, 3, 4, 3, 4,
   1, 1, 1, 1, 1, 1,
   3, 4, 2, 2, 4, 3,
   3, 4, 2, 2, 4, 3
}

local moonStone = {
   {0x001D, "Nidoran (Female)"},
   {0x001E, "Nidorina"},
   {0x001F, "Nidoqueen"},
   {0x0020, "Nidoran (Male)"},
   {0x0021, "Nidorino"},
   {0x0022, "Nidoking"},
   {0x00AD, "Cleffa"},
   {0x0023, "Clefairy"},
   {0x0024, "Clefable"},
   {0x00AE, "Igglybuff"},
   {0x0027, "Jigglypuff"},
   {0x0028, "Wigglytuff"},
   {0x012C, "Skitty"},
   {0x012D, "Delcatty"},
   {0x0205, "Munna"},
   {0x0206, "Musharna"}
}

local debugger = false
local toggle = false
print("Debugger: " .. (debugger and "ON" or "OFF"))
print("Press R + B to toggle debugger on/off")

local catchRate = nil
local modifier = nil
local modifierReal = 0x00001000
local modifierDefault = 0x00001000

local seed
local mult = 0x41C64E6D
local inc = 0x6073

local flagFast = false
local flagLevel = false
local flagLure = false
local flagHeavy = false
local flagLove = false
local flagFriend = false
local flagMoon = false
-- local flagSport = false
-- local flagPark = false
-- local flagSafari = false
local flagApri = false
local flagSprite = false

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

local function getShift(base)
   local pid = memory.readdword(base + 0x0)
   return bit.rshift(bit.band(pid, 0x3E000), 13) % 24
end

local function decrypt(base)
   local words = {}
   local checksum = memory.readword(base + 0x6)
   seed = checksum

   for i = 0, 63 do
      seed = prng()
      local key = bit.rshift(seed, 16)
      local encrypted = memory.readword(base + i * 2 + 0x8)
      words[i + 1] = bit.bxor(encrypted, key)
   end

   return words
end

local function clampCatchRate(r)
   if r < 1 then
      return 1
   elseif r > 255 then
      return 255
   else
      return r
   end
end

local function fastBall()
   local oppSpecies = memory.readword(addr.oSpecies)

   for i = 1, #speed do
      if oppSpecies == speed[i][1] then
         if oppSpecies == 0x182 or oppSpecies == 0x285 or oppSpecies == 0x288 then
            local shift = getShift(addr.baseWild)
            local offset = ((blockB[shift + 1] - 1) * 0x20) / 0x2
            local decrypted = decrypt(addr.baseWild)
            local forme = bit.band(decrypted[offset + 13], 0xF8)

            -- Deoxys (Defense), Landorus (Therian), Meloetta (Aria)
            if (oppSpecies == 0x182 and forme == 0x10) or 
               (oppSpecies == 0x285 and forme == 0x8) or
               (oppSpecies == 0x288 and forme == 0x0) then

               if debugger then
                  print("Base speed: <100")
               end
               return 1
            end
         end

         if debugger then
            print("Base speed: " .. speed[i][2])
         end
         return 4
      end
   end

   if debugger then
      print("Base speed: <100")
   end

   return 1
end

local function levelBall()
   local pLv = memory.readbyte(addr.pLevel)
   local oLv = memory.readbyte(addr.oLevel)

   local string
   local multiplier

   if pLv <= oLv then
      string = "(Player Lv) <= (Enemy Lv)"
      multiplier = 1
   elseif pLv > oLv and pLv < oLv * 2 then
      string = "(Enemy Lv) < (Player Lv) < (Enemy Lv * 2)"
      multiplier = 2
   elseif pLv >= oLv * 2 and pLv < oLv * 4 then
      string = "(Enemy Lv * 2) <= (Player Lv) < (Enemy Lv * 4)"
      multiplier = 4
   else
      string = "(Player Lv) >= (Enemy Lv * 4)"
      multiplier = 8
   end

   if debugger then
      print(string)
   end
   return multiplier
end

local function lureBall()
   local fishing = memory.readdword(addr.baseTask + 0xC) -- 0x021aa25e str r0,[r4,#0xc]  
   local multiplier = 1
   local isFishing = false
   if fishing == 6 then
      isFishing = true
      multiplier = 3
   end

   if debugger then
      print("Currently fishing: " .. tostring(isFishing))
   end
   return multiplier
end

local function heavyBall()
   local hg = memory.readword(addr.oWeight) -- hectograms
   local kg = hg / 10
   local heavyMod

   if hg <= 1023 then
      heavyMod = -20
   elseif hg >= 1024 and hg <= 2047 then
      heavyMod = 0
   elseif hg >= 2048 and hg <= 3071 then
      heavyMod = 20
   elseif hg >= 3072 and hg <= 4095 then
      heavyMod = 30
   elseif hg >= 4096 then
      heavyMod = 40
   end

   if debugger then
      print("Weight: " .. kg .. " kg")
   end

   return heavyMod
end

local function loveBall()
   local playerSpecies = memory.readword(addr.pSpecies)
   local playerGender = memory.readbyte(addr.pGender)
   local oppSpecies = memory.readword(addr.oSpecies)
   local oppGender = memory.readbyte(addr.oGender)

   local pGenderStr = genders[playerGender + 1]
   local oGenderStr = genders[oppGender + 1]

   if debugger then
      print("Species: 0x" .. getHex(playerSpecies, 4) .. ", 0x" .. getHex(oppSpecies, 4))
      print("Gender: " .. pGenderStr .. ", " .. oGenderStr)
   end

   if playerGender > 1 or oppGender > 1 then
      return 1
   end

   if playerSpecies == oppSpecies and playerGender ~= oppGender then
      return 8
   end

   return 1
end

local function friendBall(base)
   local shift = getShift(base)
   local offset = ((blockA[shift + 1] - 1) * 0x20) / 0x2
   
   local decrypted = decrypt(base)

   local baseFriendship = bit.band(decrypted[offset + 7], 0xFF)
   if debugger then
      print("Friendship: base " .. baseFriendship)
   end

   decrypted[offset + 7] = bit.bor(bit.band(decrypted[offset + 7], 0xFF00), 200)

   local checksum = 0
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
      if oppSpecies == moonStone[i][1] then
         if debugger then
            print("Evolutionary line involves Moon Stone: true")
         end
         return 4
      end
   end
   if debugger then
      print("Evolutionary line involves Moon Stone: false")
   end
   return 1
end

local function handleToggle()
   local inputs = joypad.get()
   local buttonCombo = inputs.R and inputs.B

   if buttonCombo and not toggle then
      debugger = not debugger
      toggle = true
      print("Debugger: " .. (debugger and "ON" or "OFF"))
      print("\n")
   end

   if not buttonCombo then
      toggle = false
   end
end

local function main()
   -- Overwrite inventory
   for i = 0, #items - 1 do
      local ID = addr.baseInv + i * 0x4
      local count = ID + 0x2
      --memory.writeword(ID, items[i + 1][1])
      --memory.writeword(count, 0x384)
   end

   handleToggle()
end

gui.register(main)

-- Set item category flag to 1 (Balls)
memory.registerexec(0x0220baa0, function()
   local r1 = memory.getregister("r1")
   for i = 1, #items do
      if r1 == items[i][1] then
         memory.setregister("r0", 1)
      end
   end
end)

-- Master Ball path
memory.registerexec(0x021cbae2, function()
   --memory.setregister("r3", 0x0001)
end)

-- Set modifier
memory.registerexec(0x021cbb5c, function()
   local r3 = memory.getregister("r3")

   modifier = nil
   flagFast = false
   flagLevel = false
   flagLure = false
   flagHeavy = false
   flagLove = false
   flagFriend = false
   flagMoon = false
   flagApri = false
   flagSprite = false

   if debugger then
      for i = 1, #items do
         if r3 == items[i][1] then
            print(items[i][2] .. " detected (0x" .. getHex(items[i][1], 4) .. ")")
         end
      end
   end

   -- Fast Ball
   if r3 == items[1][1] then
      modifier = modifierDefault
      flagFast = true
      flagApri = true
   end

   -- Level Ball
   if r3 == items[2][1] then
      modifier = modifierDefault
      flagLevel = true
      flagApri = true
      flagSprite = true
   end

   -- Lure Ball     
   if r3 == items[3][1] then
      modifier = modifierDefault
      flagLure = true
      flagApri = true
      flagSprite = true
   end

   -- Heavy Ball
   if r3 == items[4][1] then
      modifier = modifierDefault
      flagHeavy = true
      flagApri = true
      flagSprite = true
   end

   -- Love Ball (x8 if same species and opposite gender, x1 otherwise)
   if r3 == items[5][1] then
      modifier = modifierDefault
      flagLove = true
      flagApri = true
      flagSprite = true
   end

   -- Friend Ball (Always x1)
   if r3 == items[6][1] then
      modifier = modifierDefault
      flagFriend = true
      -- flagApri = true
      flagSprite = true
   end

   -- Moon Ball (x4 if pokemon evolves with moon stone, x1 otherwise)
   if r3 == items[7][1] then
      modifier = modifierDefault
      flagMoon = true
      flagApri = true
      flagSprite = true
   end

   -- Sport Ball (Always x1.5)
   if r3 == items[8][1] then
      modifier = modifierDefault * 1.5
      flagSprite = true
   end

   -- Park Ball (Always x1)
   if r3 == items[9][1] then
      modifier = modifierDefault
   end

   -- Safari Ball (Always x1.5)
   if r3 == items[10][1] then
      modifier = modifierDefault * 1.5
   end
end)

-- Overwrite modifier
memory.registerexec(0x021cbc1c, function()
   if modifier then
      memory.setregister("r0", modifier)
   end
   modifierReal = memory.getregister("r0")

   if debugger then
      print("Ball bonus: x" .. modifierReal / 0x1000)
      print("\n")
   end
end)

-- Change throw/shake sprites (Poke Ball)
memory.registerexec(0x021f954a, function()
   if flagSprite then
      memory.setregister("r1", 0x021E0004)
      if debugger then
         print("Sprite: Poke Ball")
         print("\n")
      end
      flatSprite = false
   end

   if flagFast and debugger then
      print("Sprite: Fast Ball -> Dream Ball")
      print("\n")
   end
end)

-- Reset flagFriend if capture fails (flag 0)
memory.registerexec(0x021cbd02, function()
   flagFriend = false
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
   if flagFriend and addToParty then
      local r1 = memory.getregister("r1") -- slot index
      local r4 = memory.getregister("r4") -- party base
      slotParty = r4 + r1 * 0xDC + 0x8
   end
end)

-- Overwrite party slot's friendship
memory.registerexec(0x021b98de, function()
   if flagFriend and addToParty and slotParty then
      friendBall(slotParty)
      flagFriend = false
      addToParty = false
      slotParty = nil

      if debugger then
         print("Friendship: set to 200 (joined party)")
         print("\n")
      end
   end
end)

-- Get PC slot base (current box)
memory.registerexec(0x0200757e, function()
   if flagFriend then
      local r0 = memory.getregister("r0")
      local r7 = memory.getregister("r7")
      slotPC = r0 + r7
   end
end)

-- Overwrite PC slot's friendship
memory.registerexec(0x0200758c, function()
   if flagFriend and slotPC then
      friendBall(slotPC)
      flagFriend = false
      slotPC = nil

      if debugger then
         print("Friendship: set to 200 (sent to PC)")
         print("\n")
      end
   end
end)

-- Modify species catch rate directly if apriball
memory.registerexec(0x021cbc08, function()
   catchRate = memory.getregister("r0")
   local catchRateMod

   if debugger then print("Species catch rate: " .. catchRate) end

   if flagApri then
      if flagFast then
         catchRateMod = clampCatchRate(catchRate * fastBall())
         memory.setregister("r0", catchRateMod)
      end

      if flagLevel then
         catchRateMod = clampCatchRate(catchRate * levelBall())
         memory.setregister("r0", catchRateMod)
      end

      if flagLure then
         catchRateMod = clampCatchRate(catchRate * lureBall())
         memory.setregister("r0", catchRateMod)
      end

      if flagHeavy then
         catchRateMod = clampCatchRate(catchRate + heavyBall())
         memory.setregister("r0", catchRateMod)
      end

      if flagLove then
         catchRateMod = clampCatchRate(catchRate * loveBall())
         memory.setregister("r0", catchRateMod)
      end

      if flagMoon then
         catchRateMod = clampCatchRate(catchRate * moonBall())
         memory.setregister("r0", catchRateMod)
      end

      flagApri = false
      if debugger then
         print("Modified catch rate: " .. catchRateMod)
      end
   end
end)
