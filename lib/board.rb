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

  def valid_length?(ship, ship_coordinates)
    ship_coordinates.count == ship.length
  end

  def consecutive_coordinates?(ship, ship_coordinates)
    if ship_coordinates.first[0] == ship_coordinates[1][0] && ship_coordinates[1][0] == ship_coordinates.last[0]
      range = ship_coordinates.first..ship_coordinates.last
      array = range.to_a
      array == ship_coordinates
    elsif ship_coordinates.first[1] == ship_coordinates[1][1] && ship_coordinates[1][1] == ship_coordinates.last[1]
      consecutive_vertical_coordinates?(ship, ship_coordinates)
    else 
      false # diagonal always returns false
    end
  end

  def consecutive_vertical_coordinates?(ship, ship_coordinates)
    ship_coordinates.each_cons(2).all? do |ship_coordinate, next_ship_coordinate|
      ship_coordinate[0].ord + 1 == next_ship_coordinate[0].ord
    end
  end

  def valid_placement?(ship, ship_coordinates)
    valid_length?(ship, ship_coordinates) &&
    consecutive_coordinates?(ship, ship_coordinates) &&
    no_overlapping_ships?(ship, ship_coordinates)
  end

  def place(ship, ship_coordinates)
    ship_coordinates.each do |coordinate|
      @cells[coordinate].place_ship(ship)
    end
  end

  def no_overlapping_ships?(ship, ship_coordinates)
    ship_coordinates.each do |coordinate|
      cell = @cells[coordinate]
      return false unless cell.empty?
    end
    true
  end

  def render(show_ships = false)
    "  1 2 3 4 \n" +
    "A #{@cells['A1'].render(show_ships)} #{@cells['A2'].render(show_ships)} #{@cells['A3'].render(show_ships)} #{@cells['A4'].render(show_ships)} \n" +
    "B #{@cells['B1'].render(show_ships)} #{@cells['B2'].render(show_ships)} #{@cells['B3'].render(show_ships)} #{@cells['B4'].render(show_ships)} \n" +
    "C #{@cells['C1'].render(show_ships)} #{@cells['C2'].render(show_ships)} #{@cells['C3'].render(show_ships)} #{@cells['C4'].render(show_ships)} \n" +
    "D #{@cells['D1'].render(show_ships)} #{@cells['D2'].render(show_ships)} #{@cells['D3'].render(show_ships)} #{@cells['D4'].render(show_ships)} \n"
  end

end