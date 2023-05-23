import numpy as np
from PIL import Image
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter, landscape
from reportlab.lib.utils import ImageReader

def place_image(c, image_path, x, y, width, height, x1_val, x2_val):
    try:
        img = Image.open(image_path)

        # Crop the image
        img = img.crop((52.5, 11.5, 535+52.5, 535+10.5))

        img_width, img_height = img.size
        aspect_ratio = img_height / img_width

        if height is None:
            height = width * aspect_ratio
        if width is None:
            width = height / aspect_ratio

        c.drawImage(ImageReader(img), x, y, width, height)

        # Add x1 and x2 labels
        label_text = f"x1: {x1_val/2:.2f}, x2: {x2_val/2:.2f}"
        c.setFont("Helvetica", 10)
        c.setFillColor("white")
        c.drawString(x, y - 15, label_text)
    except Exception as e:
        print(f"Error adding image: {e}")

# Load the x_1 and x_2 values from the CSV file
x_ii = np.loadtxt("x_ii.csv", delimiter=",")
x1_values = x_ii[0, :]
x2_values = x_ii[1, :]
margin_x = 535
margin_y = 50

# Define the output PDF size and margins
page_width, page_height = landscape(letter)
content_width = 535*32
content_height = 535*32
page_size = (content_width, content_height)

# Create a new PDF canvas with the custom page size
c = canvas.Canvas("output_pressure.pdf", pagesize=page_size)

# Image size and gap between images
width = 535
height = None
gap = 10

# Calculate the x and y positions based on the triangular grid
x_positions = 2*x1_values * (content_width - width - gap) + margin_x
y_positions = 2*x2_values * (content_height - (width if height is None else height) - gap) + margin_y

# Place images on the canvas according to the calculated positions
for i, (x, y, x1_val, x2_val) in enumerate(zip(x_positions, y_positions, x1_values, x2_values), start=1):
    image_path = f"visual_damman/pressure_peaks_{i}_.png"
    place_image(c, image_path, x, y, width, height, x1_val, x2_val)

# Save the PDF
c.save()