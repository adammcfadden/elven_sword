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
    weapon_bonus = rand((self.level* 2) + 1)

    weapon = self.weapons.where(isequipped?: true).take

    if weapon != nil
      max = weapon.max_power
      min = weapon.min_power
      weapon_bonus = rand(min..max)
    end
    (weapon_bonus*self.str/4) + (self.str * 2)
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

  def level_up(stat_points_gained)
    level = self.level
    str = self.str
    vit = self.vit
    level += 1
    stat_points_gained.times do
      roll = rand(2)
      if roll == 0
        vit +=1
      elsif roll == 1
        str +=1
      end
    end
    self.update(level: level, xp: 0, vit: vit, str: str)
    max_health = get_max_health()
    self.update(health: max_health)
  end

  def get_max_health
    vit = self.vit
    level = self.level
    max_health = vit * 15 + (level * 30)
    return max_health
  end

  def flee
    self.update(in_battle?: false)
  end

  def enter_battle
    self.update(in_battle?: true)
  end
end
