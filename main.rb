require 'rspec'
require_relative 'lib/graphic'

input = ''

while input != 'X' do
  print "COMMAND > "
  input = gets.chomp

  command = input.split(" ", 2)[0]
  args = input.split(" ", 2)[1]

  case command
  when 'I'
    begin
      graphic = Graphic.new(args)
    rescue
      puts "ERROR: Your image must be sized between 1 column and 250 rows max. Please try again."
      next
    end
  when 'L'
    graphic.colour_pixel(args)
  when 'S'
    graphic.show_current
  when 'F'
    graphic.fill_region(args)
  when 'V'
    graphic.draw_vertical_segment(args)
  when 'H'
    graphic.draw_horizontal_segment(args)
  when 'X'
    puts "Bye!"
  else
    puts "ERROR: Command not found. Please try again."
  end
end
