class Floor

  attr_reader(:width, :height, :map)

  def initialize (attributes)
    @width = attributes[:width]
    @height = attributes[:height]
    @map = Array.new(@width)
    @map.each_index() do |index|
      @map[index] = Array.new(@height, false)
    end
  end

  def fill_map (with_solid)
    @map.each_index() do |x|
      @map[x].each_index() do |y|
        set_is_solid(x, y, with_solid)
      end
    end
  end

  def create_boundaries
    @map.each_index() do |x|
      @map[x].each_index() do |y|
        if(x == 0 || y == 0 || x == @width-1 || y == @height-1)
          set_is_solid(x, y, true)
        end
      end
    end
  end

  # The "drunkard's walk" algorithim: http://www.roguebasin.com/index.php?title=Random_Walk_Cave_Generation
  def drunk_walk (steps, is_filling)
    x = (@width/2).floor()
    y = (@height/2).floor()
    set_is_solid(x, y, is_filling)
    (steps-1).times() do
      new_coordinates = random_step(x, y)
      while(!is_within_map?(new_coordinates[:x], new_coordinates[:y])) do
        new_coordinates = random_step(x, y)
      end
      x = new_coordinates[:x]
      y = new_coordinates[:y]
      set_is_solid(x, y, is_filling)
    end
  end

#   def drunk_walk_no_backtrack (steps, is_filling)
#     backtrack_map = Floor.new({:width => @width, :height => @height})
#     x = (@width/2).floor()
#     y = (@height/2).floor()
#     backtrack_map.set_is_solid(x, y, true)
#     set_is_solid(x, y, is_filling)
#     (steps-1).times() do
#       new_coords = random_step(x, y)
#       while(!is_within_map?(new_coords[:x], new_coords[:y]) || (!is_trapped?(x, y, backtrack_map) && backtrack_map.is_solid?(new_coords[:x], new_coords[:y]) )) do
#         new_coords = random_step(x, y)
#       end
#       x = new_coords[:x]
#       y = new_coords[:y]
#       backtrack_map.set_is_solid(x, y, true)
#       set_is_solid(x, y, is_filling)
# # binding.pry
#     end
#   end

  def is_trapped? (current_x, current_y, backtrack_map)
    trapped = true
    x = current_x
    y = current_y - 1
    if(is_within_map?(x, y) && !backtrack_map.is_solid?(x,y))
      trapped = false
    end
    y = current_y + 1
    if(is_within_map?(x, y) && !backtrack_map.is_solid?(x,y))
      trapped = false
    x = current_x - 1
    end
    if(is_within_map?(x, y) && !backtrack_map.is_solid?(x,y))
      trapped = false
    end
    x = current_x + 1
    if(is_within_map?(x, y) && !backtrack_map.is_solid?(x,y))
      trapped = false
    end
    return trapped
  end

  def random_step (x, y)
    direction = rand(4)
    if(direction == 0)      # step up
      y -= 1
    elsif(direction == 2)   # step down
      y += 1
    elsif(direction == 3)   # step left
      x -= 1
    else                    # step right
      x += 1
    end
    return {:x => x, :y => y}
  end

  def is_within_map? (x, y)
    return x >= 0 && y >= 0 && x < @width && y < @height
  end

  def is_solid? (x, y)
    return @map[x][y]
  end

  def set_is_solid (x, y, is_solid)
    @map[x][y] = is_solid
  end

  # BELOW FUNCTIONS FOR TESTING ONLY

  def self.make_test_floor
    return Floor.new({:width => 25, :height => 25})
  end

  def print_map
    (@height).times do |y|
      (@width).times do |x|
        if(is_solid?(x, y))
          print("#")
        else
          print(".")
        end
      end
      print("\n")
    end
  end

end
