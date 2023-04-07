require 'spec_helper'

RSpec.describe Cell do
  before(:each) do
    @cell = Cell.new('B4')
    @cell_1 = Cell.new('B3')
    @cell_2 = Cell.new('B2')
    @cruiser = Ship.new('Cruiser', 3)
  end

  describe '#initialize' do
    it 'exists' do
      expect(@cell).to be_a(Cell)
    end

    it 'has attributes' do
      expect(@cell.coordinate).to eq('B4')
      expect(@cell.ship).to be(nil)
    end
  end

  describe '#empty?' do
    it 'can check if a cell is empty' do
      expect(@cell.empty?).to be(true)
    end
  end

  describe '#place_ship' do
    it 'can place a ship' do
      @cell.place_ship(@cruiser)
      expect(@cell.ship).to eq(@cruiser)
      expect(@cell.empty?).to be(false)
    end
  end

  describe '#fired_upon' do
    it 'can check if a ship has been fired upon' do
      @cell.place_ship(@cruiser)
      expect(@cell.fired_upon?).to be(false)
    end
  end

  describe '#fire_upon' do
    it 'can fire upon a ship that occupies the cell' do
      @cell.place_ship(@cruiser)
      expect(@cell.fired_upon?).to be(false)
      @cell.fire_upon
      expect(@cell.ship.health).to eq(2)
      expect(@cell.fired_upon?).to be(true)
      @cell.fire_upon
      expect(@cell.ship.health).to eq(1)
      expect(@cell.fired_upon?).to be(true)
      @cell.fire_upon
      expect(@cell.ship.health).to eq(0)
      expect(@cell.fired_upon?).to be(true)
      expect(@cell.ship.sunk?).to be(true)
    end
  end

  describe '#render' do
    it 'can render as "." if it has not been fired upon' do
      expect(@cell).to be_a(Cell)
      expect(@cell.render).to eq(".")
    end

    it 'can render as "M" if is fired upon but missed' do
      expect(@cell.render).to eq(".")
      expect(@cell.fired_upon?).to be(false)
      @cell.fire_upon
      expect(@cell.fired_upon?).to be(true)
      expect(@cell.empty?).to be(true)
      expect(@cell.render).to eq("M")
    end

    it 'can render as "S" if it contains a ship' do
      @cell.place_ship(@cruiser)
      expect(@cell.render(true)).to eq("S")
    end

    it 'can render as "H" if fired upon and hit' do
      @cell.place_ship(@cruiser)
      @cell.fire_upon
      expect(@cell.render).to eq("H")
    end

    it 'can render as "X" if hit sunk a ship' do
      @cell.place_ship(@cruiser)
      @cell.fire_upon
      expect(@cruiser.health).to eq(2)
      expect(@cruiser.sunk?).to be(false)
      @cruiser.hit
      expect(@cruiser.health).to eq(1)
      expect(@cruiser.sunk?).to be(false)
      @cruiser.hit
      expect(@cruiser.health).to eq(0)
      expect(@cruiser.sunk?).to be(true)
      expect(@cell.render).to eq("X")
    end
  end
  
end