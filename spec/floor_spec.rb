require('rspec')
require('floor')

describe(Floor) do

  describe('#initialize') do
    it("Creates an empty floor.") do
      test_floor = Floor.new({:width => 10, :height => 10})
      expect(test_floor.map[4][4]).to(eq(false))
    end
  end

  describe('#create_boundaries') do
    it("Creates walls around the edges of the map.") do
      test_floor = Floor.new({:width => 10, :height => 10})
      test_floor.create_boundaries()
      expect(test_floor.map[0][0]).to(eq(true))
      expect(test_floor.map[0][9]).to(eq(true))
      expect(test_floor.map[9][0]).to(eq(true))
      expect(test_floor.map[9][9]).to(eq(true))
      expect(test_floor.map[4][4]).to(eq(false))
    end
  end

  describe('#is_solid?') do
    it("Returns true if the map is solid (i.e., contains a wall) at the specified coordinates.") do
      test_floor = Floor.new({:width => 10, :height => 10})
      test_floor.create_boundaries()
      expect(test_floor.is_solid?(0, 0)).to(eq(true))
      expect(test_floor.is_solid?(4, 4)).to(eq(false))
    end
  end

end
