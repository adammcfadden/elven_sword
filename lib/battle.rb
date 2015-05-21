class Battle < ActiveRecord::Base

  has_many :entities

  def self.random_monster
    roll = Random.new
    monster_roll = rand(5)

    weapon_category = nil

    if monster_roll == 0
      name = 'Ghoul'
      level = 0
      vit = 2
      strength = 20
    elsif monster_roll == 1
      name = 'Goblin'
      level = 1
      vit = 5
      strength = 10
      weapon_category = 'dagger'
  elsif monster_roll == 2
      name = 'Kobold'
      level = 0
      vit = 1
      strength = 10
      weapon_category = 'candle'
  elsif monster_roll == 3
      name = 'Orc'
      level = 3
      vit = 5
      strength = 10
      weapon_category = 'axe'
    elsif monster_roll == 4
      name = 'Nekker'
      level = 1
      vit = 8
      strength = 15
    elsif monster_roll == 5
      name = 'Mindflayer'
      level = 2
      vit = 2
      strength = 4
      weapon_category = 'wand'
    elsif monster_roll == 6
      name = 'Gorgon'
      level = 3
      vit = 15
      strength = 12
    end

    monster = Entity.create(str: strength, vit: vit, name: name, level: level, pc?: false, alive?: true)
    monster.level_up(rand(6))
    max_health = monster.get_max_health
    monster.update(health: max_health)

    if(weapon_category != nil)
      weapon = Weapon.generate_random(weapon_category)
      monster.weapons.push(weapon)
      weapon.equip
    end


    return monster
  end


  # def fetch_entities
  #   @entity0 = Entity.where(pc?: true)
  #   @entity1 = Battle.random_monster
  #   self.entities.push(@entity0)
  #   self.entities.push(@entity1)
  # end

  def attack(attacker, target)
    damage = attacker.damage
    target.take_damage(damage)
    return damage
  end

  def flee
    self.update(active?: false)
  end


end
