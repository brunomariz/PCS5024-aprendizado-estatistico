#!/usr/bin/env python3
from PIL import Image, ImageDraw, ImageFont
import os, sys

# input_dir = "results/curriculum-epochs100-past800-future400"
input_dir = sys.argv[1]
output_pdf = "training_report.pdf"

# Create all pages
pages = []
for i, png_file in enumerate(
    sorted(f for f in os.listdir(input_dir) if f.startswith("loss_curve_"))
):
    base_name = png_file[11:-4]  # Remove 'loss_curve_' and '.png'
    txt_file = f"arguments_{base_name}.txt"

    # Open images
    img_left = Image.open(f"{input_dir}/{png_file}")
    img_right = Image.new("RGB", (600, img_left.height), "white")

    # Add text
    draw = ImageDraw.Draw(img_right)
    try:
        font = ImageFont.truetype("DejaVuSansMono.ttf", 18)  # Monospace for alignment
    except:
        font = ImageFont.load_default()  # Fallback
    with open(f"{input_dir}/{txt_file}") as f:
        text = f.read()
    draw.text((20, 20), text, font=font, fill="black")

    # Combine
    page = Image.new(
        "RGB",
        (img_left.width + img_right.width, max(img_left.height, img_right.height)),
    )
    page.paste(img_left, (0, 0))
    page.paste(img_right, (img_left.width, 0))

    # Add page number
    draw = ImageDraw.Draw(page)
    page_num = f"{i+1}/{len([f for f in os.listdir(input_dir) if f.startswith('loss_curve_')])}"
    # Position at bottom center
    text_width = draw.textlength(page_num, font=font)
    draw.text(
        ((page.width - text_width - 30), page.height - 30),  # 30px from bottom right
        page_num,
        font=font,
        fill="black",
    )

    pages.append(page)

# Save PDF
pages[0].save(output_pdf, save_all=True, append_images=pages[1:], dpi=(600, 600))
print(f"Generated: {output_pdf}")
