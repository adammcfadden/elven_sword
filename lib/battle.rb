class Battle < ActiveRecord::Base

  has_many :entities

  def self.random_monster
    roll = Random.new
    monster_roll = rand(18)

    weapon_category = nil

    if monster_roll == 0
      name = 'Ghoul'
      level = 0
      vit = 1
      strength = 15
      image_path = './media/ghoul.png'
    elsif monster_roll == 1
      name = 'Goblin'
      level = 1
      vit = 3
      strength = 8
      weapon_category = 'dagger'
      image_path = './media/goblin.png'
    elsif monster_roll == 2
      name = 'Kobold'
      level = 0
      vit = 1
      strength = 2
      weapon_category = 'trinket'
      image_path = './media/kobold.png'
    elsif monster_roll == 3
      name = 'Orc'
      level = 3
      vit = 6
      strength = 10
      weapon_category = 'axe'
      image_path = './media/orc.png'
    elsif monster_roll == 4
      name = 'Nekker'
      level = 3
      vit = 10
      strength = 20
      image_path = './media/nekker.png'
    elsif monster_roll == 5
      name = 'Mindflayer'
      level = 4
      vit = 2
      strength = 4
      weapon_category = 'wand'
      image_path = './media/mindflayer.png'
    elsif monster_roll == 6
      name = 'Gorgon'
      level = 5
      vit = 30
      strength = 20
      image_path = './media/gorgon.png'
    elsif monster_roll == 7
      name = 'Cultist'
      level = 6
      vit = 12
      strength = 35
      image_path = './media/cultist.png'
      weapon_category = 'dagger'
    elsif monster_roll == 8
      name = 'Deep One'
      level = 7
      vit = 31
      str = 31
      image_path = './media/deep_one.png'
    elsif monster_roll == 9
      name = 'Skeleton Warrior'
      weapon_category = "sword"
      level = 2
      vit = 1
      str = 2
      image_path = './media/skeleton_warrior.png'
    elsif monster_roll == 10
      name = 'Skeleton Conscript'
      weapon_category = "spear"
      level = 1
      vit = 1
      str = 1
      image_path = './media/skeleton_conscript.png'
    elsif monster_roll == 11
      name = 'Skull Cluster'
      weapon_category = "arcane"
      level = 5
      vit = 10
      str = 10
      image_path = './media/skull_cluster.png'
    elsif monster_roll == 12
      name = 'Giant Moth'
      weapon_category = "arcane"
      level = 7
      vit = 4
      str = 12
      image_path = './media/giant_moth.png'
    elsif monster_roll == 13
      name = 'Beholder'
      weapon_category = "arcane"
      level = 8
      vit = 10
      str = 12
      image_path = './media/beholder.png'
    elsif monster_roll == 14
      name = 'Beast'
      level = 3
      vit = 5
      str = 20
      image_path = './media/beast.png'
    elsif monster_roll == 15
      name = 'Centaur'
      weapon_category = "hammer"
      level = 6
      vit = 10
      str = 12
      image_path = './media/centaur.png'
    elsif monster_roll == 16
      name = 'Lizard'
      weapon_category = "nature"
      level = 1
      vit = 3
      str = 12
      image_path = './media/lizard.png'
    elsif monster_roll == 17
      name = 'Chimera'
      weapon_category = "nature"
      level = 10
      vit = 30
      str = 30
      image_path = './media/chimera.png'
    end

    monster = Entity.create(str: strength, vit: vit, name: name, level: level, pc?: false, alive?: true, image_path: image_path)
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
