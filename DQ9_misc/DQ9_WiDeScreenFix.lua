local wideScreen = 0x1C71
local addrField = 0x027E38A0
local addrBattle = 0x023926CC

local function main()
   memory.writedword(addrField, wideScreen) -- field
   memory.writedword(addrBattle, wideScreen) -- battlefield
end

gui.register(main)
