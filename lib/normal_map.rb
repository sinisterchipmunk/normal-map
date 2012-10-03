require 'RMagick'

class NormalMap
  autoload :CLI,          'normal_map/cli'
  autoload :Version,      'normal_map/version'
  autoload :VERSION,      'normal_map/version'

  include Magick
  attr_reader :colors

  def initialize filename, opts = {}
    @colors = ImageList.new(filename)[0]
    opts.each do |k, v|
      instance_variable_set :"@#{k}", v
    end
    convert!
  end

  def to_blob *a, &b
    to_image.to_blob *a, &b
  end

  def print *args
    out.print *args unless silent?
  end

  def puts *args
    out.puts *args unless silent?
  end

  # If true, calculated normals will be averaged with adjacent normals
  # to produce a smoother, but less accurate, normal map.
  def smooth?
    !!@smooth
  end

  # If true, pixel coordinates out of range will be wrapped to the other
  # side of the texture; otherwise, they will be clamped to the edge of
  # the texture.
  def wrap?
    !!@wrap
  end

  # If true, nothing will be output during generation.
  def silent?
    !!@silent
  end

  # If true, normals will be calculated from diagonally adjacent pixels
  # as well as vertically and horizontally adjacent. If `smooth` is also
  # true, diagonal pixels will be considered in the smoothing algorithm
  # as well.
  def diagonal?
    !!@diagonal
  end

  # The output stream to receive status updates. Defaults to `$stdout`.
  def out
    @out ||= $stdout
  end

  def to_image
    normals
  end

  def normals
    @normals ||= Image.new width, height
  end

  def convert!
    total = width * height
    increment = 0.05
    current = 0
    frac = 1.0 / total
    pixels = Array.new total
    width.times do |x|
      height.times do |y|
        current += frac
        increment = progress current, increment
        normal = calculate_normal x, y
        normal[0] = normal[0] * 0.5 + 0.5
        normal[1] = normal[1] * 0.5 + 0.5
        normal[2] = normal[2] * 0.5 + 0.5
        pixels[offset x, y] = Pixel.new normal[0] * QuantumRange,
                                        normal[1] * QuantumRange,
                                        normal[2] * QuantumRange, 
                                        QuantumRange
      end
    end
    normals.store_pixels 0, 0, width, height, pixels
    puts
  end

  def progress percent, increment
    if percent >= increment
      print '.'
      increment += 0.05
    end
    percent = (percent*100).to_i.to_s
    print "  => ", percent, "%", "\b" * (percent.length + 6)
    increment
  end

  def pixels
    @pixels ||= colors.get_pixels 0, 0, width, height
  end

  def calculate_normal x, y
    sx, sy = width, height
    
    # vertical/horizontal
    az = intensity x+1, y
    bz = intensity x, y+1
    cz = intensity x-1, y
    dz = intensity x, y-1
    normal = normalize [cz - az, dz - bz, 2 ]

    if diagonal?
      # diagonal
      az = intensity x+1, y+1
      bz = intensity x-1, y+1
      cz = intensity x+1, y-1
      dz = intensity x-1, y-1
      normal2 = normalize [cz - az, dz - bz, 2 ]
      
      # average them together
      normal[0] = (normal[0] + normal2[0]) * 0.5
      normal[1] = (normal[1] + normal2[1]) * 0.5
      normal[2] = (normal[2] + normal2[2]) * 0.5
    end

    normal
  end

  def intensity(x, y)
    # return intensity averaged with all adjacent pixels to produce
    # a smoother result. Weight the current pixel to give it a little
    # more influence.
    if smooth?
      sum = 0.0
      sum += raw_intensity x-1, y
      sum += raw_intensity x+1, y
      sum += raw_intensity x, y-1
      sum += raw_intensity x, y+1
      if diagonal?
        sum += raw_intensity x-1, y-1
        sum += raw_intensity x-1, y+1
        sum += raw_intensity x+1, y-1
        sum += raw_intensity x+1, y+1
        sum /= 8.0
      else
        sum / 4.0
      end
    else
      raw_intensity x, y
    end
  end

  def raw_intensity(x, y)
    if wrap?
      x += width  if x < 0
      x -= width  if x >= width
      y += height if y < 0
      y -= height if y >= height
    else
      x = 0          if x <  0
      x = width  - 1 if x >= width
      y = 0          if y <  0
      y = height - 1 if y >= height
    end
    pixels[offset x, y].intensity.to_f / QuantumRange.to_f
  end

  def offset x, y
    y * width + x
  end

  def normalize vec
    mag = 1.0 / Math.sqrt(vec[0]**2 + vec[1]**2 + vec[2]**2)
    vec[0] *= mag
    vec[1] *= mag
    vec[2] *= mag
    vec
  end

  def width
    @width ||= colors.columns
  end

  def height
    @height ||= colors.rows
  end
end
