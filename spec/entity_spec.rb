require 'spec_helper'

describe Entity do

  describe '.create' do
    it 'creates a starting player with a name, health, level, and starting location of 1,1' do
      player = Entity.create(name: 'Dirge', level: 1, xp: 0, health: 100,  location_x: 1, location_y: 1, pc?: true, alive?: true)
    expect(player.name).to eq('Dirge')
    end
  end

  describe '#attack' do
    it 'returns a damage roll for the entity' do
      player = Entity.create(name: 'Dirge', level: 1, health: 100, location_x: 1, location_y: 1, pc?: true, alive?: true)
      expect(player.attack).to eq(5)
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

  describe '#take_damage' do
    it 'takes damage from an entity and subtracts the damage from remaning health' do
      player = Entity.create(name: 'Dirge', level: 1, health: 100, location_x: 1, location_y: 1, pc?: true, alive?: true)
      monster = Entity.create(name: 'Lina', level: 1, health: 100, location_x: 1, location_y: 1, pc?: true, alive?: true)
      player.take_damage(monster.attack)
      expect(player.health).to eq(95)
    end

    it 'checks if the entity is dead' do
      player = Entity.create(name: 'Dirge', level: 1, health: 100, location_x: 1, location_y: 1, pc?: true, alive?: true)
      monster = Entity.create(name: 'Lina', level: 1, health: 5, location_x: 1, location_y: 1, pc?: true, alive?: true)
      monster.take_damage(player.attack)
      expect(monster.alive?).to eq(false)
    end
  end

  describe '#win_battle' do
    it 'gives the winning entity xp' do
      player = Entity.create(name: 'Dirge', level: 1, xp: 0, health: 100, location_x: 1, location_y: 1, pc?: true, alive?: true)
      monster = Entity.create(name: 'Lina', level: 1, xp: 0, health: 100, location_x: 1, location_y: 1, pc?: true, alive?: true)
      player.win_battle(100 * monster.level)
      expect(player.xp).to eq(100)
    end
  end

  describe '#level_up' do
    it 'increases the level of the entity' do
      player = Entity.create(name: 'Dirge', level: 1, xp: 0, health: 100, location_x: 1, location_y: 1, pc?: true, alive?: true)
      player.level_up
      expect(player.level).to eq(2)
      expect(player.xp).to eq(0)
    end
  end

end
