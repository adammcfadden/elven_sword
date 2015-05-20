require 'spec_helper'

describe Weapon do

  describe '.generate_random' do
    it 'generates a random weapon based on argument weapon category' do
      weapon = Weapon.generate_random('sword')
      expect(weapon.category).to eq('sword')
    end
  end

  describe '#equip' do
    it 'switches the equipped flag to true' do
      weapon = Weapon.generate_random('sword')
      weapon.equip
      expect(weapon.isequipped?).to eq(true)
    end
  end

    describe '#unequip' do
      it 'switches the equipped flag to false' do
        weapon = Weapon.generate_random('sword')
        weapon.equip
        weapon.unequip
        expect(weapon.isequipped?).to eq(false)
      end
    end

end
