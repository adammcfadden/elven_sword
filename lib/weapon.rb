class Weapon < ActiveRecord::Base
  has_and_belongs_to_many :entities

  def self.generate_random(category)

    if category == 'sword'
      weapon = Weapon.create(name:'Sword', category: 'sword', max_power: 14, min_power: 8)
    elsif category == 'dagger'
      weapon = Weapon.create(name:'Dagger', category: 'dagger', max_power: 8, min_power: 4)
    elsif category == 'axe'
      weapon = Weapon.create(name: 'Axe', category: 'axe', max_power: 16, min_power: 8)
    elsif category == 'candle'
      weapon = Weapon.create(name: 'Candle', category: 'candle', max_power: 3, min_power: 1)
    elsif category == 'wand'
      weapon = Weapon.create(name: 'Wand', category: 'wand', max_power:25, min_power:0)
    end

  end

  def equip
    self.update(isequipped?: true)
  end

  def unequip
    self.update(isequipped?: false)
  end

end
