require 'rspec'
require_relative '../lib/graphic'

describe Graphic do
  describe '.new' do
    context 'when given the arguments "5 6"' do
      let(:graphic) { Graphic.new("5 6") }
      subject { p graphic.grid }

      it { should eql([%w(O O O O O)] * 6) }
    end

    context 'when given the arguments "3 4"' do
      let(:graphic) { Graphic.new("3 4") }
      subject { p graphic.grid }

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
    context 'when given the argument "3 3 J"' do
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
  end

  describe '#draw_vertical_segment' do
    let(:graphic) { Graphic.new("5 6") }
    before do
      graphic.colour_pixel("2 3 A")
      graphic.fill_region("3 3 J")
    end

    context 'when given the argument "2 3 4 W"' do
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

    context 'when given the argument "2 3 5 W"' do
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

    context 'when given the argument "3 4 2 Z"' do
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

    context 'when given the argument "3 5 2 Z"' do
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
