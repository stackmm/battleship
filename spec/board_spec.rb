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

  describe '#valid_placement?' do
    it 'can check for valid ship length' do
      expect(@board.valid_placement?(@cruiser, ['A1', 'A2'])).to be(false)
      expect(@board.valid_placement?(@submarine, ['A2', 'A3', 'A4'])).to be(false)
    end
  end
end