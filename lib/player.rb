class Player
  attr_accessor :x, :y, :player_drawn
  def initialize(window)
    @image = Gosu::Image.new(window, "media/fox.png", false)
    @width = 16
    @x = 1
    @y = 1
    @player_drawn = false
  end

  def randomize_coords
    @x = Random.new.rand(1..78)
    @y = Random.new.rand(1..78)
  end

  def draw_player
    @player_drawn = true
  end

  def warp(x, y)
    @x = x
    @y = y
  end

  def walk_left
      @x -= 1
  end

  def walk_right
      @x += 1
  end

  def walk_up
      @y -= 1
  end

  def walk_down
      @y += 1
  end

  def draw
    @image.draw(@x*16, @y*16, 1)
  end
end
