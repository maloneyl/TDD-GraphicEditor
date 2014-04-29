require 'rspec'
require_relative '../lib/graphic'

describe Graphic do
  describe '.new' do
    context 'when given the arguments "5 6"' do
      let(:graphic) { Graphic.new("5 6") }
      subject { graphic.grid }

      it { should eql([%w(O O O O O)] * 6) }
    end

    context 'when given the arguments "3 4"' do
      let(:graphic) { Graphic.new("3 4") }
      subject { graphic.grid }

      it { should eql([%w(O O O)] * 4) }
    end

    context 'when given the arguments "0 9"' do
      it 'should raise an ArgumentError' do
        expect { Graphic.new("0 9") }.to raise_error(ArgumentError)
      end
    end

    context 'when given the arguments "5 251"' do
      it 'should raise an ArgumentError' do
        expect { Graphic.new("5 251") }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#colour_pixel' do
    context 'when given the arguments "2 3 A"' do
      let(:graphic) { Graphic.new("5 6") }

      before do
        graphic.colour_pixel("2 3 A")
      end

      subject { graphic.grid }

      it { should eql(
          [%w(O O O O O),
           %w(O O O O O),
           %w(O A O O O),
           %w(O O O O O),
           %w(O O O O O),
           %w(O O O O O)
          ]
        )}
    end
  end

  describe '#clear' do
    context 'when called after creating an 5x6 image and colouring the pixel(2, 3) with the colour A' do
      let(:graphic) { Graphic.new("5 6") }

      before do
        graphic.colour_pixel("2 3 A")
      end

      subject { graphic.clear }
      it { should eql([%w(O O O O O)] * 6) }
    end
  end

  describe '#show_current' do
    context 'when called after creating an 5x6 image and colouring the pixel(2, 3) with the colour A' do
      let(:graphic) { Graphic.new("5 6") }

      before do
        graphic.colour_pixel("2 3 A")
      end

      subject { graphic.show_current }
      it { should eql(
          [%w(O O O O O),
           %w(O O O O O),
           %w(O A O O O),
           %w(O O O O O),
           %w(O O O O O),
           %w(O O O O O)
          ]
        )}
    end
  end

  describe '#fill_region' do
    context 'when given the argument "3 3 J" and called after creating an 5x6 image and colouring the pixel(2, 3) with the colour A' do
      let(:graphic) { Graphic.new("5 6") }

      before do
        graphic.colour_pixel("2 3 A")
        graphic.fill_region("3 3 J")
      end

      subject { graphic.grid }
      it { should eql(
          [%w(J J J J J),
           %w(J J J J J),
           %w(J A J J J),
           %w(J J J J J),
           %w(J J J J J),
           %w(J J J J J)
          ]
        )}
    end

    context 'when given the argument "1 1 A" and called after creating an 5x5 image' do
      let(:graphic) { Graphic.new("5 5") }

      before do
        graphic.fill_region("1 1 A")
      end

      subject { graphic.grid }
      it { should eql([%w(A A A A A)] * 5)}
    end

    context 'when given the argument "2 3 X" and called after creating an 5x6 image and the colour A scattered within' do
      let(:graphic) { Graphic.new("5 6") }
      before do
        graphic.colour_pixel("3 2 A")
        graphic.colour_pixel("4 2 A")
        graphic.colour_pixel("3 3 A")
        graphic.colour_pixel("1 4 A")
        graphic.colour_pixel("2 4 A")
        graphic.colour_pixel("4 4 A")
        graphic.colour_pixel("5 4 A")
        graphic.fill_region("2 3 X")
      end

      subject { graphic.grid }
      it { should eql(
          [%w(X X X X X),
           %w(X X A A X),
           %w(X X A X X),
           %w(A A O A A),
           %w(O O O O O),
           %w(O O O O O)
          ]
        )}
    end

    context 'when given the argument "5 5 B" and called after creating an 10x10 image and the colour A forming a ring from (2, 2) to (9, 9)' do
      let(:graphic) { Graphic.new("10 10") }
      before do
        graphic.draw_horizontal_segment("2 9 2 A")
        graphic.draw_horizontal_segment("2 9 9 A")
        graphic.draw_vertical_segment("2 2 9 A")
        graphic.draw_vertical_segment("9 2 9 A")
        graphic.fill_region("5 5 B")
      end

      subject { graphic.grid }
      it { should eql(
          [%w(O O O O O O O O O O),
           %w(O A A A A A A A A O),
           %w(O A B B B B B B A O),
           %w(O A B B B B B B A O),
           %w(O A B B B B B B A O),
           %w(O A B B B B B B A O),
           %w(O A B B B B B B A O),
           %w(O A B B B B B B A O),
           %w(O A A A A A A A A O),
           %w(O O O O O O O O O O)
          ]
        )}
    end
  end

  describe '#radial_fill' do # 'R 3 3 A B'
    context 'when given the argument "3 3 A B" and called after creating an 5x6 image' do
      let(:graphic) { Graphic.new("5 6") }

      before do
        graphic.radial_fill("3 3 A B")
      end

      subject { graphic.grid }
      it { should eql(
          [%w(O O O O O),
           %w(O B B B O),
           %w(O B A B O),
           %w(O B B B O),
           %w(O O O O O),
           %w(O O O O O)
          ]
        )}
    end

    context 'when given the argument "1 1 A B" and called after creating an 5x7 image' do
      let(:graphic) { Graphic.new("5 7") }

      before do
        graphic.radial_fill("1 1 A B")
      end

      subject { graphic.grid }
      it { should eql(
          [%w(A B O O O),
           %w(B B O O O),
           %w(O O O O O),
           %w(O O O O O),
           %w(O O O O O),
           %w(O O O O O),
           %w(O O O O O)
          ]
        )}
    end
  end

  describe '#draw_vertical_segment' do
    let(:graphic) { Graphic.new("5 6") }
    before do
      graphic.colour_pixel("2 3 A")
      graphic.fill_region("3 3 J")
    end

    context 'when given the argument "2 3 4 W" and called after creating an 5x6 image, colouring the pixel(2, 3) with the colour A, and filling the region pixel(3, 3) with the colour J' do
      before do
        graphic.draw_vertical_segment("2 3 4 W") # 1 2 3
      end

      subject { graphic.grid }
      it { should eql(
          [%w(J J J J J),
           %w(J J J J J),
           %w(J W J J J), # grid[2][1]
           %w(J W J J J), # grid[3][1]
           %w(J J J J J),
           %w(J J J J J)
          ]
        )}
    end

    context 'when given the argument "2 3 5 W" and called after creating an 5x6 image, colouring the pixel(2, 3) with the colour A, and filling the region pixel(3, 3) with the colour J' do
      before do
        graphic.draw_vertical_segment("2 3 5 W")
      end

      subject { graphic.grid }
      it { should eql(
          [%w(J J J J J),
           %w(J J J J J),
           %w(J W J J J),
           %w(J W J J J),
           %w(J W J J J),
           %w(J J J J J)
          ]
        )}
    end
  end

  describe '#draw_horizontal_segment' do
    let(:graphic) { Graphic.new("5 6") }
    before do
      graphic.colour_pixel("2 3 A")
      graphic.fill_region("3 3 J")
      graphic.draw_vertical_segment("2 3 4 W")
    end

    context 'when given the argument "3 5 2 Z" and called after creating an 5x6 image, colouring the pixel(2, 3) with the colour A, filling the region pixel(3, 3) with the colour J, and drawing a vertical segment at (2, 3-4)' do
      before do
        graphic.draw_horizontal_segment("3 4 2 Z") # 2 3 1
      end

      subject { graphic.grid }
      it { should eql(
          [%w(J J J J J),
           %w(J J Z Z J), # grid[1][2], grid[1][3]
           %w(J W J J J),
           %w(J W J J J),
           %w(J J J J J),
           %w(J J J J J)
          ]
        )}
    end

    context 'when given the argument "3 5 2 Z" and called after creating an 5x6 image, colouring the pixel(2, 3) with the colour A, filling the region pixel(3, 3) with the colour J, and drawing a vertical segment at (2, 3-4)' do
      before do
        graphic.draw_horizontal_segment("3 5 2 Z")
      end

      subject { graphic.grid }
      it { should eql(
          [%w(J J J J J),
           %w(J J Z Z Z),
           %w(J W J J J),
           %w(J W J J J),
           %w(J J J J J),
           %w(J J J J J)
          ]
        )}
    end
  end

end
