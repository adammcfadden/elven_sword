class Battle < ActiveRecord::Base

  has_many :entities

  def self.random_monster
    roll = Random.new
    monster_roll = rand(7)

    weapon_category = nil

    if monster_roll == 0
      name = 'Ghoul'
      level = 0
      vit = 2
      str = 20
      image_path = './media/ghoul.png'
    elsif monster_roll == 1
      name = 'Goblin'
      level = 1
      vit = 5
      str = 10
      weapon_category = 'dagger'
      image_path = './media/goblin.png'
    elsif monster_roll == 2
      name = 'Kobold'
      level = 0
      vit = 4
      str = 10
      weapon_category = 'trinket'
      image_path = './media/kobold.png'
    elsif monster_roll == 3
      name = 'Orc'
      level = 3
      vit = 12
      str = 10
      weapon_category = 'axe'
      image_path = './media/orc.png'
    elsif monster_roll == 4
      name = 'Nekker'
      level = 3
      vit = 18
      str = 20
      image_path = './media/nekker.png'
    elsif monster_roll == 5
      name = 'Mindflayer'
      level = 4
      vit = 2
      str = 4
      weapon_category = 'wand'
      image_path = './media/mindflayer.png'
    elsif monster_roll == 6
      name = 'Gorgon'
      level = 5
      vit = 30
      str = 20
      image_path = './media/gorgon.png'
    elsif monster_roll == 7
      name = 'Cultist'
      level = 6
      vit = 12
      str = 35
      image_path = './media/cultist.png'
      weapon_category = 'dagger'
    elsif monster_roll == 8
      name = 'Deep One'
      level = 7
      vit = 31
      str = 31
      image_path = './media/deep_one.png'
    end

    monster = Entity.create(str: str, vit: vit, name: name, level: level, pc?: false, alive?: true, image_path: image_path)
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

  def self.random_boss
    name = 'Neo-Alucard'
    level = 12
    vit = 40
    str = 40
    image_path = './media/boss.png'
    weapon_category = 'artifact'

    monster = Entity.create(str: str, vit: vit, name: name, level: level, pc?: false, alive?: true, image_path: image_path)
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
