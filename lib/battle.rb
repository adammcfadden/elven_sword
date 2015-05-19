class Battle < ActiveRecord::Base

  has_many :entities


  def self.random_monster
    roll = Random.new
    monster_roll = roll.rand(0..4)

    if monster_roll == 0
      name = 'Ghoul'
      level = 1
      health = 50
    elsif monster_roll == 1
      name = 'Goblin'
      level = 2
      health = 100
    elsif monster_roll == 2
      name = 'Kobold'
      level = 1
      health = 25
    elsif monster_roll == 3
      name = 'Orc'
      level = 4
      health = 200
    elsif monster_roll == 4
      name = 'Nekker'
      level = 2
      health = 150
    end

    monster = Entity.create(name: name, level: level, health: health, pc?: false, alive?: true)
    return monster
  end


  def fetch_entities
    monster = Entity.create(name: 'Roshan', level: 1, health: 100,  location_x: 1, location_y: 1, pc?: false, alive?: true)
    self.entities.push(Entity.where(pc?: true))
    self.entities.push(monster)
  end


end
