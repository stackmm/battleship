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

end