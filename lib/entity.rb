class Entity < ActiveRecord::Base
  belongs_to(:battle)
  attr_accessor :location_x, :location_y, :player_drawn

#   def initialize(window)
# # not being used, could be useful later
# #   @player_width = 16
#     @window = window
#     @location_x = 1
#     @location_y = 1
#     @player_drawn = false
#   end

  def image_create(window)
    @entity_image = Gosu::Image.new(window, "#{self.image_path}", false)
  end

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

  def take_damage(damage)
    health = self.health
    health -= damage
    self.update(health: health)
    self.update(alive?: false) if health == 0
  end

  def win_battle(xp_reward)
    xp = self.xp
    xp += xp_reward
    self.update(xp: xp)
  end

  def level_up
    level = self.level
    level += 1
    self.update(level: level, xp: 0)
  end


end
