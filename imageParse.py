from PIL import Image
import os

def split_image(image_path, tile_width, tile_height, output_folder):
    # Create output folder
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Open image
    try:
        img = Image.open(image_path)
    except FileNotFoundError:
        print(f"Error: Could not find {image_path}")
        return

    img_width, img_height = img.size
    tile_count = 0

    # Loop columns then rows
    for x in range(0, img_width, tile_width):
        for y in range(0, img_height, tile_height):
            box = (x, y, x + tile_width, y + tile_height)
            tile = img.crop(box)
            filename = f"tile_{tile_count:03d}.png"
            tile.save(os.path.join(output_folder, filename))
            tile_count += 1

    print(f"Success! Generated {tile_count} tiles in the '{output_folder}' folder.")

split_image('mapSprites.png', 16, 16, 'output_tiles')
