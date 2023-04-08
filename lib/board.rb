class Board
  attr_reader :cells
  def initialize
    @cells = {
      'A1' => Cell.new('A1'),
      'A2' => Cell.new('A2'),
      'A3' => Cell.new('A3'),
      'A4' => Cell.new('A4'),
      'B1' => Cell.new('B1'),
      'B2' => Cell.new('B2'),
      'B3' => Cell.new('B3'),
      'B4' => Cell.new('B4'),
      'C1' => Cell.new('C1'),
      'C2' => Cell.new('C2'),
      'C3' => Cell.new('C3'),
      'C4' => Cell.new('C4'),
      'D1' => Cell.new('D1'),
      'D2' => Cell.new('D2'),
      'D3' => Cell.new('D3'),
      'D4' => Cell.new('D4')
    }
  end

  def valid_coordinate?(coordinate)  
    @cells.keys.include?(coordinate)
  end

  def valid_placement?(ship, ship_coordinates)
    ## first validates ship length
    valid_length?(ship, ship_coordinates) && 

    ## if the ship is being placed vertically --> check for valid vertical placement
    if ship_coordinates.first[1] == ship_coordinates[1][1] && ship_coordinates[1][1] == ship_coordinates.last[1]
      valid_vertical?(ship, ship_coordinates)
    else ## otherwise checks for valid horizontal placement if not vertical (diagonals will fail this check)
      valid_horizontal?(ship, ship_coordinates)
    end
  end

  def valid_length?(ship, ship_coordinates)
    ship_coordinates.count == ship.length
  end

  def valid_horizontal?(ship, ship_coordinates)
    range = ship_coordinates.first..ship_coordinates.last
    array = range.to_a
    array == ship_coordinates
  end

  # check for appropriate vertical placement by looking at each consecutive pair of coordinates
  # ie: ["B1", "C1"], then ["C1", "D1"], and assessing if the letters are consecutive ordinal values
  def valid_vertical?(ship, ship_coordinates)
    ship_coordinates.each_cons(2).all? do |ship_coordinate, next_ship_coordinate|
      # ship_coordinate[1] == next_ship_coordinate[1] &&
      ship_coordinate[0].ord + 1 == next_ship_coordinate[0].ord
    end
  end

end