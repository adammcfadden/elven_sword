class Weapon < ActiveRecord::Base
  has_and_belongs_to_many :entities

  def self.generate_random(category)

    if category == 'sword'
      weapon = Weapon.create(name:'Sword', category: 'sword', max_power: 12, min_power: 8)
    elsif category == 'dagger'
      weapon = Weapon.create(name:'Dagger', category: 'dagger', max_power: 8, min_power: 4)
    end
    weapon
  end

  def equip
    self.update(isequipped?: true)
  end

  def unequip
    self.update(isequipped?: false)
  end

end
