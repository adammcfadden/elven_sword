require('rspec')
require('floor')

describe(Floor) do

  describe('#initialize') do
    it("Creates an empty floor.") do
      test_map = Floor.new({:width => 10, :height => 10})
      expect(test_map.map[4][4]).to(eq(false))
    end
  end

end
