class Weapon < ActiveRecord::Base
  has_and_belongs_to_many :entities

  def self.generate_random(category)
    if category == 'sword'
      roll = rand(2)
      if roll == 0
        weapon = Weapon.create(name:'Long Sword', category: 'sword', max_power: 12, min_power: 8)
      else
        weapon = Weapon.create(name:'Short Sword', category: 'sword', max_power: 8, min_power: 6)
      end
    elsif category == 'dagger'
      roll = rand(2)
      if roll == 0
      weapon = Weapon.create(name:'Rusty Dagger', category: 'dagger', max_power: 6, min_power: 3)
      else
        weapon = Weapon.create(name:'Ceremonial Dagger', category: 'dagger', max_power: 8, min_power: 4)
      end
    elsif category == 'axe'
      roll = rand(2)
      if roll == 0
      weapon = Weapon.create(name: 'Hatchet', category: 'axe', max_power: 10, min_power: 2)
      else
        weapon = Weapon.create(name: 'Logging Axe', category: 'axe', max_power: 16, min_power: 4)
      end
    elsif category == 'trinket'
      roll = rand(2)
      if roll == 0
        weapon = Weapon.create(name: 'Candle', category: 'trinket', max_power: 2, min_power: 1)
      else
        weapon = Weapon.create(name: 'Sharp Rock', category: 'trinket', max_power: 4, min_power: 3)
      end
    elsif category == 'wand'
      roll = rand(2)
      if roll == 0
        weapon = Weapon.create(name: 'Runed Stick', category: 'wand', max_power: 15, min_power: 0)
      else
        weapon = Weapon.create(name: 'Ancient Wand', category: 'wand', max_power: 25, min_power: 0)
      end
    elsif category == 'spear'
      roll = rand(2)
      if roll == 0
        weapon = Weapon.create(name: 'Pointed Stick', category: 'spear', max_power:8, min_power: 0)
      else
        weapon = Weapon.create(name: 'Stout Spear', category: 'spear', max_power:16, min_power: 8)
      end
    elsif category == 'arcane'
      roll = rand(3)
      if roll == 0
        weapon = Weapon.create(name: 'Flaming Skull', category: 'arcane', max_power:30, min_power:6 )
      elsif roll == 1
        weapon = Weapon.create(name: 'Moth Wing', category: 'arcane', max_power:40, min_power: 8)
      else
        weapon = Weapon.create(name: 'Beholder Eye', category: 'arcane', max_power:26, min_power: 15)
      end
    elsif category == 'hammer'
      roll = rand(2)
      if roll == 0
        weapon = Weapon.create(name: 'Spiked Maul', category: 'hammer', max_power:22, min_power: 12)
      else
        weapon = Weapon.create(name: 'Great Hammer', category: 'hammer', max_power:32, min_power: 2)
      end
    elsif category == 'nature'
      roll = rand(2)
      if roll == 0
        weapon = Weapon.create(name: 'Poisoned Fang', category: 'nature', max_power:16, min_power: 12)
      else
        weapon = Weapon.create(name: 'Vicious Claw', category: 'nature', max_power:18, min_power: 14)
      end
    elsif category == 'artifact'
      roll = rand(3)
      if roll == 0
        weapon = Weapon.create(name: 'Demon Claw', category: 'artifact', max_power: 30, min_power: 20)
      elsif roll == 1
        weapon = Weapon.create(name: 'Beholder Eye', category: 'artifact', max_power: 45, min_power: 0)
      else
        weapon = Weapon.create(name: 'Deep One Heart', category: 'artifact', max_power: 25, min_power: 25)
      end
    end
  end

  def equip
    self.update(isequipped?: true)
  end

  def unequip
    self.update(isequipped?: false)
  end

end
