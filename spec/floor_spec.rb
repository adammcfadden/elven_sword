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

  describe('#fill_map') do
    it("Fills the whole map as either solid or empty space.") do
      test_floor = Floor.new({:width => 10, :height => 10})
      test_floor.fill_map(true)
      expect(test_floor.map[4][4]).to(eq(true))
      test_floor.fill_map(false)
      expect(test_floor.map[4][4]).to(eq(false))
    end
  end

  describe('#drunk_walk') do
    it("Performs the drunkard's walk generation algorithim, clearing or filling for a given number of steps.") do
      test_floor = Floor.new({:width => 20, :height => 20})
      test_floor.fill_map(true)
      steps = 100
      test_floor.drunk_walk(steps, false)
      test_floor.create_boundaries()
      print("\n\nDrunkard's Walk [#{steps} steps]:\n\n")
      test_floor.print_map()
      print("\n")
    end
  end

  describe('#is_trapped?') do
    it("Returns true if there are no empty spaces above, below, or to the sides of the specified coordinate in a given floor.") do
      test_floor = Floor.new({:width => 20, :height => 20})
      test_floor.fill_map(true)
      test_floor.set_is_solid(4, 4, false)
      expect(test_floor.is_trapped?(4, 4, test_floor)).to(eq(true))
    end
  end

  describe('#is_within_map?') do
    it("Returns true if the specified coordinates are within the map's boundaries.") do
      test_floor = Floor.new({:width => 10, :height => 10})
      expect(test_floor.is_within_map?(0, 0)).to(eq(true))
      expect(test_floor.is_within_map?(9, 9)).to(eq(true))
      expect(test_floor.is_within_map?(-1, -1)).to(eq(false))
      expect(test_floor.is_within_map?(10, 10)).to(eq(false))
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

  describe('#set_is_solid') do
    it("Sets the map to be solid or empty at the specified coordinates.") do
      test_floor = Floor.new({:width => 10, :height => 10})
      test_floor.set_is_solid(4, 4, true)
      expect(test_floor.is_solid?(4, 4)).to(eq(true))
      test_floor.set_is_solid(4, 4, false)
      expect(test_floor.is_solid?(4, 4)).to(eq(false))
    end
  end

end
