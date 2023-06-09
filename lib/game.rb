class Game 
  attr_reader :player_board, :computer_board, :player_ships, :computer_ships
  def initialize
    @player_board = Board.new
    @computer_board = Board.new
    @player_ships = []
    @computer_ships = []
  end

  def main_menu
    system "clear"
    welcome_message
    puts "Enter p to play. Enter q to quit."
    input = gets.chomp.downcase[0]
    if input == "p"
      setup_game
      play_game
    elsif input == "q"
      puts "Game Ended"
      exit
    else 
      puts "Invalid Input. Please try again"
      sleep(2)
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
      all_coordinates = @computer_board.cells.keys
      coordinates = []
      until @computer_board.valid_placement?(ship, coordinates)
        coordinates = all_coordinates.sample(ship.length)
      end
      @computer_board.place(ship, coordinates)
    end
  end

  def place_player_ships
    system "clear"
    puts "I have laid out my ships on the grid."
    puts "You now need to lay out your two ships."
    puts "The Cruiser is three units long and the Submarine is two units long."
    puts @player_board.render(true)
    @player_ships << player_ship_input(Ship.new('Cruiser', 3))
    system "clear"
    puts @player_board.render(true)
    @player_ships << player_ship_input(Ship.new('Submarine', 2))
    system "clear"
  end

  def player_ship_input(ship)
    puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"
    input = gets.chomp.upcase.split
    until @player_board.valid_placement?(ship, input)

      puts "Those are invalid coordinates. Please try again:"
      input = gets.chomp.upcase.split
    end
    @player_board.place(ship, input)
    ship
  end
  
  def play_game
    until game_over?
      system "clear"
      display_boards
      shoot_player
      shoot_computer
    end

    if computer_lost?
      winner_message
    else
      puts "I won!"
    end
    play_again?
  end

  def display_boards
    puts "=============COMPUTER BOARD============="
    puts @computer_board.render
    puts "\n==============PLAYER BOARD=============="
    puts @player_board.render(true)
  end

  def shoot_player
    puts "\nEnter the coordinate for your shot:"
    input = gets.chomp.upcase
    until @computer_board.valid_coordinate?(input) && !@computer_board.cells[input].fired_upon?
      if !@computer_board.valid_coordinate?(input)
        puts "Please enter a valid coordinate:"
      elsif @computer_board.cells[input].fired_upon?
        puts "You have already fired on #{input}. Please choose another coordinate."
      end
      input = gets.chomp.upcase
    end
    @computer_board.cells[input].fire_upon
    results_player(input)
  end

  def shoot_computer
    input = @player_board.cells.keys.sample
    until !@player_board.cells[input].fired_upon?
      input = @player_board.cells.keys.sample
    end
    @player_board.cells[input].fire_upon
    results_computer(input)
    sleep(1)
  end

  def results_player(coordinate)
    cell = @computer_board.cells[coordinate]
    if cell.fired_upon?
      if cell.empty?
        puts "Your shot on #{coordinate} was a miss."
      else
        puts "Your shot on #{coordinate} was a hit."
        if cell.ship.sunk?
          puts "You sunk my #{cell.ship.name}!"
        end
      end
    end
  end

  def results_computer(coordinate)
    cell = @player_board.cells[coordinate]
    if cell.fired_upon?
      if cell.empty?
        puts "My shot on #{coordinate} was a miss."
      else
        puts "My shot on #{coordinate} was a hit."
        if cell.ship.sunk?
          puts "I sunk your #{cell.ship.name}!"
        end
      end
    end
  end

  def game_over?
    player_lost? || computer_lost?
  end

  def player_lost?
    @player_ships.all? do |ship|
      ship.sunk?
    end
  end

  def computer_lost?
    @computer_ships.all? do |ship|
      ship.sunk?
    end
  end

  def play_again?
    puts "Would you like to restart the game? (y/n)"
    input = gets.chomp.downcase[0]
    if input == 'y'
      clear_boards
      main_menu
    elsif input == 'n'
      exit
    else
      puts "Invalid response. Please try again."
      play_again?
    end
  end

  def clear_boards
    @player_board = Board.new
    @computer_board = Board.new
    @player_ships = []
    @computer_ships = []
  end

  def welcome_message
    puts <<-'EOF'

    ____    __    ____  _______  __        ______   ______   .___  ___.  _______    
    \   \  /  \  /   / |   ____||  |      /      | /  __  \  |   \/   | |   ____|   
     \   \/    \/   /  |  |__   |  |     |  ,----'|  |  |  | |  \  /  | |  |__      
      \            /   |   __|  |  |     |  |     |  |  |  | |  |\/|  | |   __|     
       \    /\    /    |  |____ |  `----.|  `----.|  `--'  | |  |  |  | |  |____    
        \__/  \__/     |_______||_______| \______| \______/  |__|  |__| |_______|   
                                                                                
        EOF
        sleep(1)
    puts <<-'EOF'

                        .___________.     ______   
                        |           |    /  __  \  
                        `---|  |----`   |  |  |  | 
                            |  |        |  |  |  | 
                            |  |        |  `--'  | 
                            |__|         \______/  
                                                  
    EOF
    sleep(1)
    puts <<-'EOF'
    ██████   █████  ████████ ████████ ██      ███████ ███████ ██   ██ ██ ██████  
    ██   ██ ██   ██    ██       ██    ██      ██      ██      ██   ██ ██ ██   ██ 
    ██████  ███████    ██       ██    ██      █████   ███████ ███████ ██ ██████  
    ██   ██ ██   ██    ██       ██    ██      ██           ██ ██   ██ ██ ██      
    ██████  ██   ██    ██       ██    ███████ ███████ ███████ ██   ██ ██ ██      
 
    EOF
    sleep(2)
  end

  def winner_message
    puts <<-'EOF'
    __      __   ______   __    __         ______   _______   ________                        
    |  \    /  \ /      \ |  \  |  \       /      \ |       \ |        \                       
     \$$\  /  $$|  $$$$$$\| $$  | $$      |  $$$$$$\| $$$$$$$\| $$$$$$$$                       
      \$$\/  $$ | $$  | $$| $$  | $$      | $$__| $$| $$__| $$| $$__                           
       \$$  $$  | $$  | $$| $$  | $$      | $$    $$| $$    $$| $$  \                          
        \$$$$   | $$  | $$| $$  | $$      | $$$$$$$$| $$$$$$$\| $$$$$                          
        | $$    | $$__/ $$| $$__/ $$      | $$  | $$| $$  | $$| $$_____                        
        | $$     \$$    $$ \$$    $$      | $$  | $$| $$  | $$| $$     \                       
         \$$      \$$$$$$   \$$$$$$        \$$   \$$ \$$   \$$ \$$$$$$$$                       
                                                                                     
                       ________  __    __  ________                                            
                      |        \|  \  |  \|        \                                           
                       \$$$$$$$$| $$  | $$| $$$$$$$$                                           
                         | $$   | $$__| $$| $$__                                               
                         | $$   | $$    $$| $$  \                                              
                         | $$   | $$$$$$$$| $$$$$                                              
                         | $$   | $$  | $$| $$_____                                            
                         | $$   | $$  | $$| $$     \                                           
                          \$$    \$$   \$$ \$$$$$$$$                                           
                                                                                                                                                                                
     __       __        ______        __    __        __    __        ________        _______  
    |  \  _  |  \      |      \      |  \  |  \      |  \  |  \      |        \      |       \ 
    | $$ / \ | $$       \$$$$$$      | $$\ | $$      | $$\ | $$      | $$$$$$$$      | $$$$$$$\
    | $$/  $\| $$        | $$        | $$$\| $$      | $$$\| $$      | $$__          | $$__| $$
    | $$  $$$\ $$        | $$        | $$$$\ $$      | $$$$\ $$      | $$  \         | $$    $$
    | $$ $$\$$\$$        | $$        | $$\$$ $$      | $$\$$ $$      | $$$$$         | $$$$$$$\
    | $$$$  \$$$$       _| $$_       | $$ \$$$$      | $$ \$$$$      | $$_____       | $$  | $$
    | $$$    \$$$      |   $$ \      | $$  \$$$      | $$  \$$$      | $$     \      | $$  | $$
     \$$      \$$       \$$$$$$       \$$   \$$       \$$   \$$       \$$$$$$$$       \$$   \$$
    EOF
  end
end