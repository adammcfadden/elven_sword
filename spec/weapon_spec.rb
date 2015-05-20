require 'spec_helper'

describe Weapon do

  describe '.generate_random' do
    it 'generates a random weapon based on argument weapon category' do
      weapon = Weapon.generate_random('sword')
      expect(weapon.category).to eq('sword')
    end
  end

end
