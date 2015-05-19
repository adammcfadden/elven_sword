class Entity < ActiveRecord::Base

  def damage
    return 5
  end

  def move_north
    location = self.location_y
    location += 1
    self.update(location_y: location)
  end

  def move_south
    location = self.location_y
    location -= 1
    self.update(location_y: location)
  end

  def move_east
    location = self.location_x
    location += 1
    self.update(location_x: location)
  end

  def move_west
    location = self.location_x
    location -= 1
    self.update(location_x: location)
  end


end
