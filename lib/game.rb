class Game 


  def main_menu
    p 'Welcome to BATTLESHIP'
    p 'Enter p to play. Enter q to quit.'
    response = gets.chomp
      if response == "p"
        start_game
      elsif response == "q"
        p "Game Ended"
      end
  end

  def start_game
    p 'I have laid out my ships on the grid.'
    p 'You now need to lay out your two ships.'
    p 'The Cruiser is three units long and the Submarine is two units long.'
    
  end
end

