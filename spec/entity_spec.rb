require 'spec_helper'

describe Entity do

  describe '.create' do
    it 'creates a starting player with a name, health, level, and starting location of 1,1' do
      player = Entity.create(name: 'Dirge', level: 1, health: 100, location_x: 1, location_y: 1, pc?: true, alive?: true)
    expect(player.name).to eq('Dirge')
    end
  end

  describe '#damage' do
    it 'returns a damage roll for the entity' do
      player = Entity.create(name: 'Dirge', level: 1, health: 100, location_x: 1, location_y: 1, pc?: true, alive?: true)
      expect(player.damage).to eq(5)
    end
  end

  describe '#move_north' do
    it 'moves an entity one spot north' do
      player = Entity.create(name: 'Dirge', level: 1, health: 100, location_x: 1, location_y: 1, pc?: true, alive?: true)
      player.move_north
      expect(player.location_y).to eq(2)
    end
  end

  describe '#move_east' do
    it 'moves an entity one spot east' do
      player = Entity.create(name: 'Dirge', level: 1, health: 100, location_x: 1, location_y: 1, pc?: true, alive?: true)
      player.move_east
      expect(player.location_x).to eq(2)
    end
  end
end
