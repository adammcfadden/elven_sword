require 'spec_helper'

describe Battle do

  describe '#fetch_entities' do
    it 'adds the entities to the battle' do
      monster = Entity.create(name: 'Roshan', level: 1, xp: 0, health: 100,  location_x: 1, location_y: 1, pc?: false, alive?: true)
      player = Entity.create(name: 'Dirge', level: 1, xp: 0, health: 100,  location_x: 1, location_y: 1, pc?: true, alive?: true)
      battle = Battle.new(name: 'Battle!', boss?: false)
      battle.fetch_entities
      expect(battle.entities).to include(player)
    end
  end

end
