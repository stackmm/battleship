class Game 
  def initialize
    @player_board = Board.new
    @computer_board = Board.new
    @player_ships = []
    @computer_ships = []
  end

  def main_menu
    system "clear"
    p "Welcome to BATTLESHIP"
    p "Enter p to play. Enter q to quit."
    input = gets.chomp.downcase
    if input == "p"
      setup_game
      play_game
    elsif input == "q"
      p "Game Ended"
      exit
    else 
      p "Invalid Input. Please try again"
      main_menu
    end
  end

  def setup_game
    place_computer_ships
    place_player_ships
  end


end