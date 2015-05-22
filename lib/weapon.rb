class Weapon < ActiveRecord::Base
  has_and_belongs_to_many :entities

  def self.generate_random(category)
    if category == 'trinket'
      roll = rand(2)
      if roll == 0
        weapon = Weapon.create(name: 'Candle', category: 'trinket', max_power: 2, min_power: 1)
      else
        weapon = Weapon.create(name: 'Sharp Rock', category: 'trinket', max_power: 3, min_power: 2)
    end
    elsif category == 'dagger'
      roll = rand(2)
      if roll == 0
      weapon = Weapon.create(name:'Rusty Dagger', category: 'dagger', max_power: 5, min_power: 3)
      else
        weapon = Weapon.create(name:'Ceremonial Dagger', category: 'dagger', max_power: 8, min_power: 4)
      end
    elsif category == 'spear'
      roll = rand(2)
      if roll == 0
        weapon = Weapon.create(name: 'Pointed Stick', category: 'spear', max_power:12, min_power: 0)
      else
        weapon = Weapon.create(name: 'Sturdy Spear', category: 'spear', max_power:12, min_power: 6)
      end
    elsif category == 'sword'
      roll = rand(2)
      if roll == 0
        weapon = Weapon.create(name:'Long Sword', category: 'sword', max_power: 12, min_power: 8)
      else
        weapon = Weapon.create(name:'Short Sword', category: 'sword', max_power: 10, min_power: 6)
      end
    elsif category == 'axe'
      roll = rand(2)
      if roll == 0
      weapon = Weapon.create(name: 'Hatchet', category: 'axe', max_power: 18, min_power: 4)
      else
        weapon = Weapon.create(name: 'Logging Axe', category: 'axe', max_power: 22, min_power: 6)
      end
    elsif category == 'wand'
      roll = rand(2)
      if roll == 0
        weapon = Weapon.create(name: 'Runed Stick', category: 'wand', max_power: 28, min_power: 0)
      else
        weapon = Weapon.create(name: 'Ancient Wand', category: 'wand', max_power: 34, min_power: 0)
      end
    elsif category == 'nature'
      roll = rand(2)
      if roll == 0
        weapon = Weapon.create(name: 'Poisoned Fang', category: 'nature', max_power:20, min_power: 14)
      else
        weapon = Weapon.create(name: 'Vicious Claw', category: 'nature', max_power:26, min_power: 14)
      end
    elsif category == 'hammer'
      roll = rand(2)
      if roll == 0
        weapon = Weapon.create(name: 'Spiked Maul', category: 'hammer', max_power:30, min_power: 10)
      else
        weapon = Weapon.create(name: 'Great Hammer', category: 'hammer', max_power:36, min_power: 7)
      end
    elsif category == 'arcane'
      roll = rand(3)
      if roll == 0
        weapon = Weapon.create(name: 'Flaming Skull', category: 'arcane', max_power:24, min_power:20 )
      elsif roll == 1
        weapon = Weapon.create(name: 'Moth Wing', category: 'arcane', max_power:42, min_power: 10)
      else
        weapon = Weapon.create(name: 'Beholder Eye', category: 'arcane', max_power:51, min_power: 5)
      end


    elsif category == 'artifact'
      roll = rand(3)
      if roll == 0
        weapon = Weapon.create(name: 'Necronomicon', category: 'artifact', max_power: 60, min_power: 0)
      elsif roll == 1
        weapon = Weapon.create(name: 'Heart of Tarrasque', category: 'artifact', max_power: 45, min_power: 25)
      else
        weapon = Weapon.create(name: 'Elven Sword', category: 'artifact', max_power: 90, min_power: 30)
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
