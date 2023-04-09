require 'spec_helper'

RSpec.describe Board do
  before(:each) do
    @board = Board.new
    @cruiser = Ship.new('Cruiser', 3)
    @submarine = Ship.new('Submarine', 2)
  end

  describe '#initialize' do
    it 'exists' do
      expect(@board).to be_a(Board)
    end
    it 'has cells attributes' do
      expect(@board.cells).to be_a(Hash)
      expect(@board.cells.count).to eq(16)
      expect(@board.cells.values.first).to be_a(Cell)
    end
  end

  describe '#valid_coordinate?' do
    it 'can validate coordinates' do
      expect(@board.valid_coordinate?('A1')).to be(true)
      expect(@board.valid_coordinate?('D4')).to be(true)
      expect(@board.valid_coordinate?('A5')).to be(false)
      expect(@board.valid_coordinate?('E1')).to be(false)
      expect(@board.valid_coordinate?('A22')).to be(false)
    end
  end

  describe '#valid_length?' do
    it 'can check for valid ship length' do
      expect(@board.valid_length?(@cruiser, ['A1', 'A2'])).to be(false)
      expect(@board.valid_length?(@submarine, ['A2', 'A3', 'A4'])).to be(false)
      expect(@board.valid_length?(@cruiser, ['B2', 'C2', 'D2'])).to be(true)
      expect(@board.valid_length?(@submarine, ['A4', 'B4'])).to be(true)
    end
  end

  describe '#consecutive_coordinates?' do
    it 'can check for consecutive horizontal coordinates' do
      expect(@board.consecutive_coordinates?(@cruiser, ['A1', 'A2', 'A4'])).to be(false)
      expect(@board.consecutive_coordinates?(@submarine, ['A1', 'C1'])).to be(false)
      expect(@board.consecutive_coordinates?(@cruiser, ['A3', 'A2', 'A1'])).to be(false)
      expect(@board.consecutive_coordinates?(@submarine, ['C1', 'B1'])).to be(false)
      expect(@board.consecutive_coordinates?(@submarine, ['B1', 'B2'])).to be(true)
      expect(@board.consecutive_coordinates?(@cruiser, ['D2', 'D3', 'D4'])).to be(true)
      expect(@board.consecutive_coordinates?(@cruiser, ['A1', 'B2', 'C3'])).to be(false)
    end
  end

  describe '#consecutive_vertical_coordinates?' do
    it 'can check for consecutive vertical coordinates' do
      expect(@board.consecutive_vertical_coordinates?(@submarine, ['A1', 'A2'])).to be(false)
      expect(@board.consecutive_vertical_coordinates?(@cruiser, ['C2', 'C3', 'C4'])).to be(false)
      expect(@board.consecutive_vertical_coordinates?(@cruiser, ['A1', 'B1', 'C1'])).to be(true)
      expect(@board.consecutive_vertical_coordinates?(@submarine, ['C2', 'D2'])).to be(true)
      expect(@board.consecutive_vertical_coordinates?(@cruiser, ['B3', 'C3', 'D3'])).to be(true)
    end
  end

  describe '#valid_placement?' do
    it 'it can check for valid ship length and consecutive horizontal/vertical coordinates' do
      expect(@board.valid_placement?(@cruiser, ['A1', 'B2', 'C3'])).to be(false)
      expect(@board.valid_placement?(@submarine, ['C2', 'D3'])).to be(false)
      expect(@board.valid_placement?(@cruiser, ['D1', 'C2', 'B3'])).to be(false)
      expect(@board.valid_placement?(@submarine, ['A1', 'A2'])).to be(true)
      expect(@board.valid_placement?(@submarine, ['C3', 'C4'])).to be(true)
      expect(@board.valid_placement?(@cruiser, ['B1', 'C1', 'D1'])).to be(true)
      expect(@board.valid_placement?(@cruiser, ['A1', 'B1', 'C1'])).to be(true)
      expect(@board.valid_placement?(@cruiser, ['B3', 'C3', 'D3'])).to be(true)
    end
  end

  describe '#place' do 
    it 'can place a ship' do 
      @board.place(@cruiser, ['A1', 'A2', 'A3'])
      cell_1 = @board.cells['A1']
      cell_2 = @board.cells['A2']
      cell_3 = @board.cells['A3']
      expect(cell_1.ship).to eq(@cruiser)
      expect(cell_2.ship).to eq(@cruiser)
      expect(cell_3.ship).to eq(@cruiser)
      expect(cell_1.ship).to eq(cell_2.ship)
      expect(cell_2.ship).to eq(cell_3.ship)
      expect(cell_1.ship).to eq(cell_3.ship)
    end
  end

  describe '#no_overlapping_ships' do
    it 'can check for overlapping ships' do
      expect(@board.no_overlapping_ships?(@submarine, ['A1', 'B1'])).to be(true)
      @board.place(@cruiser, ['A1', 'A2', 'A3'])
      expect(@board.no_overlapping_ships?(@submarine, ['A1', 'B1'])).to be(false)
    end

    it 'can check for overlapping ships from the #valid_placement? method' do
      expect(@board.valid_placement?(@cruiser, ['A2', 'B2', 'C2'])).to be(true)
      @board.place(@submarine, ['A2', 'A3'])
      expect(@board.valid_placement?(@cruiser, ['A2', 'B2', 'C2'])).to be(false)
    end
  end
  
  describe '#render' do
    it 'can render a board without boats' do
      expect(@board.render).to eq("  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n")
    end

    it 'can render a boat' do
      expect(@board.render).to eq("  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n")
      @board.place(@cruiser, ['A1', 'A2', 'A3'])
      cell_1 = @board.cells['A1']
      cell_2 = @board.cells['A2']
      cell_3 = @board.cells['A3']
      expect(cell_1.empty?).to eq(false)
      expect(cell_2.empty?).to eq(false)
      expect(cell_3.empty?).to eq(false)
      expect(@board.render(true)).to eq("  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n")
    end

    it 'can render a boat and render a miss' do
      expect(@board.render).to eq("  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n")
      @board.place(@cruiser, ['A1', 'A2', 'A3'])
      cell_1 = @board.cells['A1']
      cell_2 = @board.cells['A2']
      cell_3 = @board.cells['A3']
      cell_4 = @board.cells['A4']
      expect(cell_1.empty?).to eq(false)
      expect(cell_2.empty?).to eq(false)
      expect(cell_3.empty?).to eq(false)
      expect(@board.render(true)).to eq("  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n")
      cell_4.fire_upon
      expect(cell_4.fired_upon?).to eq(true)
      expect(cell_4.empty?).to eq(true)
      expect(cell_4.render).to eq('M')
      expect(@board.render(true)).to eq("  1 2 3 4 \nA S S S M \nB . . . . \nC . . . . \nD . . . . \n")
    end

    it 'can render a boat and render a hit' do
      expect(@board.render).to eq("  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n")
      @board.place(@cruiser, ['A1', 'A2', 'A3'])
      cell_1 = @board.cells['A1']
      cell_2 = @board.cells['A2']
      cell_3 = @board.cells['A3']
      expect(cell_1.empty?).to eq(false)
      expect(cell_2.empty?).to eq(false)
      expect(cell_3.empty?).to eq(false)
      expect(@board.render(true)).to eq("  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n")
      cell_1.fire_upon
      expect(cell_1.fired_upon?).to eq(true)
      expect(cell_1.empty?).to eq(false)
      expect(cell_1.render).to eq('H')
      expect(@board.render).to eq("  1 2 3 4 \nA H . . . \nB . . . . \nC . . . . \nD . . . . \n")
    end

    it 'can render a boat and render a sink' do
      expect(@board.render).to eq("  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n")
      @board.place(@cruiser, ['A1', 'A2', 'A3'])
      cell_1 = @board.cells['A1']
      cell_2 = @board.cells['A2']
      cell_3 = @board.cells['A3']
      expect(cell_1.empty?).to eq(false)
      expect(cell_2.empty?).to eq(false)
      expect(cell_3.empty?).to eq(false)
      expect(@board.render(true)).to eq("  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n")
      cell_1.fire_upon
      expect(cell_1.fired_upon?).to eq(true)
      expect(cell_1.empty?).to eq(false)
      expect(cell_1.render).to eq('H')
      expect(@board.render).to eq("  1 2 3 4 \nA H . . . \nB . . . . \nC . . . . \nD . . . . \n")
      cell_2.fire_upon
      expect(cell_2.fired_upon?).to eq(true)
      expect(cell_2.empty?).to eq(false)
      expect(cell_2.render).to eq('H')
      expect(@board.render).to eq("  1 2 3 4 \nA H H . . \nB . . . . \nC . . . . \nD . . . . \n")
      cell_3.fire_upon
      expect(cell_3.fired_upon?).to eq(true)
      expect(cell_3.empty?).to eq(false)
      expect(cell_3.render).to eq('X')
      expect(@board.render).to eq("  1 2 3 4 \nA X X X . \nB . . . . \nC . . . . \nD . . . . \n")
    end

    it 'renders a boat, a miss, a hit, and a sink' do
      expect(@board.render).to eq("  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n")
      @board.place(@cruiser, ['A1', 'A2', 'A3'])
      @board.place(@submarine, ['B1', 'C1'])
      cell_1 = @board.cells['A1']
      cell_2 = @board.cells['A2']
      cell_3 = @board.cells['A3']
      cell_4 = @board.cells['B1']
      cell_5 = @board.cells['C1']
      cell_6 = @board.cells['D1']
      expect(@board.render(true)).to eq("  1 2 3 4 \nA S S S . \nB S . . . \nC S . . . \nD . . . . \n")
      cell_1.fire_upon
      cell_4.fire_upon
      cell_5.fire_upon
      cell_6.fire_upon
      expect(@board.render(true)).to eq("  1 2 3 4 \nA H S S . \nB X . . . \nC X . . . \nD M . . . \n")
    end
  end

end