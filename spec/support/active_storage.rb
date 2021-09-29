def png_file
  { io: File.open(Rails.root.join('spec', 'files', 'image.png')), filename: 'image.png', content_type: 'image/png' }
end

def jpg_file
  { io: File.open(Rails.root.join('spec', 'files', 'image.jpg')), filename: 'image.jpg', content_type: 'image/jpg' }
end

def gif_file
  { io: File.open(Rails.root.join('spec', 'files', 'image.gif')), filename: 'image.gif', content_type: 'image/gif' }
end

def tiff_file
  { io: File.open(Rails.root.join('spec', 'files', 'image.tiff')), filename: 'image.tiff', content_type: 'image/tiff' }
end

def big_image_file
  # https://eoimages.gsfc.nasa.gov/images/imagerecords/74000/74393/world.topo.200407.3x5400x2700.png
  { io: File.open(Rails.root.join('spec', 'files', 'big_image.png')), filename: 'big_image.png', content_type: 'image/png' }
end

def pdf_file
  { io: File.open(Rails.root.join('spec', 'files', 'document.pdf')), filename: 'document.pdf', content_type: 'application/pdf' }
end

def assets_image(filename="placeholder.png", content_type="image/png")
  { io: File.open(Rails.root.join('app', 'assets', 'images', filename)), filename: filename, content_type: content_type }
end

def assets_image_path(filename="placeholder.png")
  Rails.root.join('app', 'assets', 'images', filename)
end