-- Original script and bmp file by mkdasher
-- https://github.com/mkdasher/desmume-widescreen

Config = {}

Config.Settings = {
  INPUT_DISPLAY_COLORS = {
    button_pressed = 0xffffffff,
    button_unpressed = 0x00000030,
    layout_fill = 0xd8d8d8ff,
    layout_border = 0x000000ff,
    background = 0x00ff00ff
  },
}

Input = {}

function Input.getJoypad()
  return joypad.get(1)
end

Bitmap = { buffer = {}, cache = {} }

function Bitmap.bytes_to_int(b1, b2, b3, b4)
  local n = b1 + b2*256 + b3*65536 + b4*16777216
  return (n > 2147483647) and (n - 4294967296) or n
end

function Bitmap.bytes_to_color(b1, b2, b3)
  return 255 + b3 * 0x1000000 + b2 * 0x10000 + b1 * 0x100
end

function Bitmap.readPixel(buffer)
  local bytes = buffer:read(3)
  return Bitmap.bytes_to_color(bytes:byte(1,3))
end

function Bitmap.readInt(buffer)
  local bytes = buffer:read(4)
  return Bitmap.bytes_to_int(bytes:byte(1,4))
end

function Bitmap.readImage(filename)
  if Bitmap.buffer[filename] then return end

  local buffer = io.open(filename, "rb")
  if not buffer then return end

  local image = {}
  buffer:read(10)
  local initData = Bitmap.readInt(buffer)
  Bitmap.readInt(buffer)
  image.width = Bitmap.readInt(buffer)
  image.height = Bitmap.readInt(buffer)

  buffer:seek('set', initData)

  for i=1,image.height do
    for j=1,image.width do
      if i == 1 then image[j] = {} end
      image[j][image.height-i+1] = Bitmap.readPixel(buffer)
    end
    if image.width * 3 % 4 > 0 then
      buffer:read(4 - (image.width * 3) % 4)
    end
  end

  buffer:close()
  Bitmap.buffer[filename] = image
end

function Bitmap.getCacheKey(filename, finalPalette, scale)
  return filename .. "|" .. table.concat(finalPalette, ",") .. "|" .. (scale or 1)
end

function Bitmap.scaleCached(cached, scale)
  if not scale or scale == 1 then return cached end

  local scaled = { width = math.floor(cached.width * scale), height = math.floor(cached.height * scale), pixels = {} }

  for y = 1, scaled.height do
    scaled.pixels[y] = {}
    for x = 1, scaled.width do
      local srcX = math.floor((x - 1) / scale) + 1
      local srcY = math.floor((y - 1) / scale) + 1
      scaled.pixels[y][x] = cached.pixels[srcY][srcX]
    end
  end

  return scaled
end

function Bitmap.buildCache(filename, palette, finalPalette)
  Bitmap.readImage(filename)
  local image = Bitmap.buffer[filename]

  local cached = { width = image.width, height = image.height, pixels = {} }

  for i=1,image.height do
    cached.pixels[i] = {}
    for j=1,image.width do
      local color = image[j][i]
      for k=1,#palette do
        if palette[k] == color then
          color = finalPalette[k]
          break
        end
      end
      cached.pixels[i][j] = color
    end
  end

  return cached
end

function Bitmap.drawCached(x, y, cached)
  for i=1,cached.height do
    for j=1,cached.width do
      local color = cached.pixels[i][j]
      if color ~= 0x00ff00ff then
        gui.drawpixel(x + j, y + i, color)
      end
    end
  end
end

function Bitmap.printImageIndexed(x,y,filename,palette,finalPalette,scale)
  local key = Bitmap.getCacheKey(filename, finalPalette, scale)

  if not Bitmap.cache[key] then
    local base = Bitmap.buildCache(filename, palette, finalPalette)
    Bitmap.cache[key] = Bitmap.scaleCached(base, scale)
  end

  Bitmap.drawCached(x, y, Bitmap.cache[key])
end

function Bitmap.loadAllBitmaps()
  Bitmap.readImage('resources/input_display.bmp')
end

Bitmap.loadAllBitmaps()

function fm()
  local j = Input.getJoypad()

  -- Default: 5, 130
  local x, y = 170, -70
  local scale = 0.5

  local colors = Config.Settings.INPUT_DISPLAY_COLORS

  local palette = {
    0x000000ff, 0xff0000ff, 0x008000ff, 0xff8000ff,
    0x00ff00ff, 0xffff00ff, 0x800080ff, 0x808080ff,
    0x0000ffff, 0x00ffffff, 0xff00ffff, 0xff80ffff,
    0xffffffff
  }

  local finalPalette = {
    colors.layout_border,
    j.left and colors.button_pressed or colors.button_unpressed,
    j.L and colors.button_pressed or colors.button_unpressed,
    j.B and colors.button_pressed or colors.button_unpressed,
    colors.background,
    j.down and colors.button_pressed or colors.button_unpressed,
    j.up and colors.button_pressed or colors.button_unpressed,
    j.R and colors.button_pressed or colors.button_unpressed,
    j.right and colors.button_pressed or colors.button_unpressed,
    j.A and colors.button_pressed or colors.button_unpressed,
    j.X and colors.button_pressed or colors.button_unpressed,
    j.Y and colors.button_pressed or colors.button_unpressed,
    colors.layout_fill
  }

  Bitmap.printImageIndexed(x, y, "resources/input_display.bmp", palette, finalPalette, scale)
end

gui.register(fm)
