class Battle < ActiveRecord::Base
  has_many :entities


  def fetch_entities
    monster = Entity.create(name: 'Roshan', level: 1, xp: 0, health: 100,  location_x: 1, location_y: 1, pc?: false, alive?: true)
    self.entities.push(Entity.where(pc?: true))
    self.entities.push(monster)
  end

end
