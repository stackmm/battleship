class Game 
  attr_reader :player, :computer

  def initialize
    @player = Player.new
    @computer = Player.new
  end

  def main_menu
    p 'Welcome to BATTLESHIP'
    p 'Enter p to play. Enter q to quit.'
    response = gets.chomp
      if response == "p"
        start_game
      elsif response == "q"
        p "Game Ended"
        main_menu
      else "Invalid Input"
        main_menu
      end
  end

  def start_game
    p 'I have laid out my ships on the grid.'
    p 'You now need to lay out your two ships.'
    p 'The Cruiser is three units long and the Submarine is two units long.'
    p @player.board.render
  end
end

