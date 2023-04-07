require 'spec_helper'

RSpec.describe Cell do
  before(:each) do
    @cell = Cell.new('B4')
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
  
end