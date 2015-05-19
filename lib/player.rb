class Player
  attr_accessor :x, :y
  def initialize(window)
    @image = Gosu::Image.new(window, "media/fox.png", false)
    @width = 16
    @x = 10
    @y = 10
  end

  def warp(x, y)
    x = @x
    y = @y
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
