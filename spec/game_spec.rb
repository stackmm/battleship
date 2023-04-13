require 'spec_helper'

RSpec.describe Game do
  describe '#initialize' do
    it 'exits' do
      game = Game.new
      expect(game).to be_a(Game)
    end

    it 'has attributes' do
      game = Game.new
      expect(game.player_board).to be_a(Board)
      expect(game.computer_board).to be_a(Board)
      expect(game.player_ships).to eq([])
      expect(game.computer_ships).to eq([])
    end
  end
end