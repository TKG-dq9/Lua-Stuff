local base = 0x02312794
local length = 0x100

-- Modes: 1 (bytes), 2 (16)
local mode = 2
local bytesPerLine = 16

local function getHex(decimal, digits)
   return string.format("%0"..digits.."X", decimal)
end

print("Base address: 0x" .. getHex(base, 8))
print("Dump length: 0x" .. getHex(length, 2))
print("\n")

local lineBuffer = {}

for i = 0, length - 1 do
   local byte = memory.readbyte(base + i)
   local hex = getHex(byte, 2)

   if mode == 1 then
      print(hex)
   else
      table.insert(lineBuffer, hex)
      
      if #lineBuffer == bytesPerLine then
         print(table.concat(lineBuffer, ", "))
         lineBuffer = {}
      end
   end
end

if mode == 2 and #lineBuffer > 0 then
   print(table.concat(lineBuffer, ", "))
end

print("\n")
