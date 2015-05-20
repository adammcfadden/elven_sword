class Entity < ActiveRecord::Base
  belongs_to :battle
  has_and_belongs_to_many :weapons

  def entity_is_drawn
    self.update(entity_drawn?: true)
  end

  def randomize_coords
    self.update(location_x: Random.new.rand(1..(BOARD_WIDTH-1)))
    self.update(location_y: Random.new.rand(1..(BOARD_WIDTH-1)))
  end

  def damage
    self.str * 5 / 10
  end

  def move_north
    location = self.location_y
    location -= 1
    self.update(location_y: location)
  end

  def move_south
    location = self.location_y
    location += 1
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
    self.update(alive?: false) if health <= 0
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
