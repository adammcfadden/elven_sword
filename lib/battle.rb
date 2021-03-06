class Battle < ActiveRecord::Base

  has_many :entities


#monsters are balanced with the following goals:
# - STR and VIT are roughly equal
# - Entities have 'x' budget points to spend between str and vit, where x = ((level^2)/3)+10
# - Monsters are leveled up once with a random stat gain (for variation between otherwise identical monsters)
  def self.random_monster
    roll = Random.new
    monster_roll = rand(17)

    weapon_category = nil

    if monster_roll == 0
      name = 'Ghoul'
      level = 0
      vit = 4
      str = 3
      image_path = './media/ghoul.png'
    elsif monster_roll == 1
      name = 'Kobold'
      level = 0
      vit = 2
      str = 2
      weapon_category = 'trinket'
      image_path = './media/kobold.png'
    elsif monster_roll == 2
      name = 'Lizard'
      level = 1
      vit = 4
      str = 4
      image_path = './media/lizard.png'
    elsif monster_roll == 3
      name = 'Goblin'
      level = 0
      vit = 2
      str = 4
      weapon_category = 'dagger'
      image_path = './media/goblin.png'
    elsif monster_roll == 4
      name = 'Skeleton Conscript'
      weapon_category = "spear"
      level = 1
      vit = 4
      str = 5
      image_path = './media/skeleton_conscript.png'
    elsif monster_roll == 5
      name = 'Skeleton Warrior'
      weapon_category = "sword"
      level = 2
      vit = 5
      str = 7
      image_path = './media/skeleton_warrior.png'
  elsif monster_roll == 6
      name = 'Orc'
      level = 3
      vit = 7
      str = 6
      weapon_category = 'axe'
      image_path = './media/orc.png'
  elsif monster_roll == 7
      name = 'Nekker'
      level = 3
      vit = 7
      str = 10
      image_path = './media/nekker.png'
    elsif monster_roll == 8
      name = 'Mindflayer'
      level = 4
      vit = 4
      str = 9
      weapon_category = 'wand'
      image_path = './media/mindflayer.png'
    elsif monster_roll == 9
      name = 'Gorgon'
      level = 4
      vit = 16
      str = 8
      image_path = './media/gorgon.png'
    elsif monster_roll == 10
      name = 'Skull Cluster'
      weapon_category = "nature"
      level = 5
      vit = 6
      str = 13
      image_path = './media/skull_cluster.png'
    elsif monster_roll == 11
      name = 'Cultist'
      level = 6
      vit = 4
      str = 18
      image_path = './media/cultist.png'
      weapon_category = 'dagger'
    elsif monster_roll == 12
      name = 'Centaur'
      weapon_category = "hammer"
      level = 6
      vit = 12
      str = 10
      image_path = './media/centaur.png'
    elsif monster_roll == 13
      name = 'Deep One'
      level = 7
      vit = 14
      str = 14
      image_path = './media/deep_one.png'
    elsif monster_roll == 14
      name = 'Giant Moth'
      weapon_category = "arcane"
      level = 7
      vit = 8
      str = 20
      image_path = './media/giant_moth.png'
    elsif monster_roll == 15
      name = 'Beholder'
      weapon_category = "arcane"
      level = 8
      vit = 20
      str = 14
      image_path = './media/beholder.png'
    elsif monster_roll == 16
      name = 'Chimera'
      weapon_category = "nature"
      level = 9
      vit = 20
      str = 20
      image_path = './media/chimera.png'
    end

    monster = Entity.create(str: str, vit: vit, name: name, level: level, pc?: false, alive?: true, image_path: image_path)
    monster.level_up(rand(monster.level + 1))
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
    vit = 30
    str = 30
    image_path = './media/boss.png'
    weapon_category = 'artifact'

    monster = Entity.create(str: str, vit: vit, name: name, level: level, pc?: false, alive?: true, image_path: image_path)
    monster.level_up(rand(12))
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
