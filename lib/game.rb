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

  def place_computer_ships
    cruiser = Ship.new('Cruiser', 3)
    submarine = Ship.new('Submarine', 2)
    @computer_ships << cruiser
    @computer_ships << submarine
    @computer_ships.each do |ship|
      coordinates = []
      loop do
        coordinates = random_coordinates(ship)
        break if @computer_board.valid_placement?(ship, coordinates)
      end
      @computer_board.place(ship, coordinates)
    end
  end
  
  def random_coordinates(ship)
    all_coordinates = @computer_board.cells.keys
    random_index = rand(all_coordinates.length)
    all_coordinates.slice(random_index, ship.length)
  end

  def place_player_ships
    system "clear"
    p "I have laid out my ships on the grid."
    p "You now need to lay out your two ships."
    p "The Cruiser is three units long and the Submarine is two units long."
    p @player_board.render(true)
    @player_ships << player_ship_input(Ship.new('Cruiser', 3))
    system "clear"
    p @player_board.render(true)
    @player_ships << player_ship_input(Ship.new('Submarine', 2))
  end

  def player_ship_input(ship)
    loop do
      p "Enter the squares for the #{ship.name} (#{ship.length} spaces):"
      input = gets.chomp.upcase.split
      if @player_board.valid_placement?(ship, input)
        @player_board.place(ship, input)
        break
      else
        p "Those are invalid coordinates. Please try again:"
      end
    end
    ship
  end

end