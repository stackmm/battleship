class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end

  def empty?
    if @ship == nil
      true
    else
      false
    end
  end

  def place_ship(ship)
    @ship = ship
  end

  def fired_upon?
    @fired_upon
  end

  def fire_upon
    @fired_upon = true
    if empty? == false
      @ship.hit
    end
  end

  def render(show_ship = false)
    if fired_upon? == true && empty? == true
      "M"
    elsif fired_upon? == true && @ship.sunk? == true && empty? == false
      "X"
    elsif fired_upon? == true && empty? == false
      "H"
    elsif empty? == false && show_ship == true
      "S"
    else
      "."
    end
  end
end