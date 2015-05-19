class Floor

  attr_reader(:width, :height, :map)

  def initialize (attributes)
    @width = attributes[:width]
    @height = attributes[:height]
    @map = Array.new(@height)
    @map.each_index() do |row_index|
      @map[row_index] = Array.new(@width, false)
    end
  end

  def create_boundaries
    @map.each_index() do |y|
      @map[y].each_index() do |x|
        if(x == 0 || y == 0 || x == @width-1 || y == @height-1)
          @map[x][y] = true
        end
      end
    end
  end

  def is_solid? (x, y)
    return @map[x][y]
  end

  # BELOW FUNCTIONS FOR TESTING ONLY

  def self.make_test_floor
    return Floor.new({:width => 25, :height => 25})
  end

  def print_map
    @map.each_index() do |y|
      @map[y].each_index() do |x|
        if(@map[x][y])
          print('#')
        else
          print('.')
        end
      end
      print("\n")
    end
  end

end
