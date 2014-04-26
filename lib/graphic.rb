class Graphic

  attr_reader :grid

  def initialize(size) # e.g. "5 6" where M = 5, N = 6
    size = size.split(" ").map(&:to_i)
    @cols = size[0]
    @rows = size[1]
    raise ArgumentError.new("There must be at least 1 column and no more than 250 rows") if @cols < 1 || @rows > 250
    @grid = Array.new(@rows) { Array.new(@cols, 'O') }
  end

  def colour_pixel(pixel_and_colour) # e.g. "2 3 A" where X = 2, Y = 3, colour = A
    pixel_and_colour = pixel_and_colour.split(" ")
    pixel_x = pixel_and_colour[0].to_i - 1
    pixel_y = pixel_and_colour[1].to_i - 1
    colour = pixel_and_colour[2]

    @grid[pixel_y][pixel_x] = colour
  end

  def clear
    @grid = Array.new(@rows) { Array.new(@cols, 'O') }
  end

  def show_current
    @grid.each do |row|
      puts row.join(" ")
    end
  end

  def fill_region(pixel_and_colour) # e.g. "3 3 J" where X = 3, Y = 3, colour = J
    pixel_and_colour = pixel_and_colour.split(" ")
    pixel_x = pixel_and_colour[0].to_i - 1
    pixel_y = pixel_and_colour[1].to_i - 1
    colour = pixel_and_colour[2]
    existing_colour = @grid[pixel_y][pixel_x]

    fill(pixel_x, pixel_y, existing_colour, colour)
  end

  def fill(x, y, existing_colour, replacement_colour)
    return if @grid[y][x] != existing_colour
    return if @grid[y][x] == replacement_colour

    @grid[y][x] = replacement_colour
    fill(x+1, y, existing_colour, replacement_colour) if x < @rows
    fill(x-1, y, existing_colour, replacement_colour) if x > 0
    fill(x, y+1, existing_colour, replacement_colour) if y < @cols
    fill(x, y-1, existing_colour, replacement_colour) if y > 0
  end

  def draw_vertical_segment(pixels_and_colour) # e.g. "2 3 4 W" where X = 2, Y1 = 3, Y2 = 4, colour = W
    pixels_and_colour = pixels_and_colour.split(" ")
    pixel_x = pixels_and_colour[0].to_i - 1
    pixel_y1 = pixels_and_colour[1].to_i - 1
    pixel_y2 = pixels_and_colour[2].to_i - 1
    colour = pixels_and_colour[3]

    @grid.each_with_index do |row, row_index|
      if row_index >= pixel_y1 && row_index <= pixel_y2
        row[pixel_x] = colour
      end
    end
  end

  def draw_horizontal_segment(pixels_and_colour) # e.g. "3 4 2 Z" where X1 = 3, X2 = 4, Y = 2, colour = Z
    pixels_and_colour = pixels_and_colour.split(" ")
    pixel_x1 = pixels_and_colour[0].to_i - 1
    pixel_x2 = pixels_and_colour[1].to_i - 1
    pixel_y = pixels_and_colour[2].to_i - 1
    colour = pixels_and_colour[3]

    @grid[pixel_y].each_with_index do |elem, elem_index|
      if elem_index >= pixel_x1 && elem_index <= pixel_x2
        @grid[pixel_y][elem_index] = colour
      end
    end
  end

end
