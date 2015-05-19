class Player
  def initialize(window)
    @image = Gosu::Image.new(window, "media/one.png", false)
    @width = 16
    @x = GameWindow::WIDTH/2
    @y = GameWindow::HEIGHT/2
  end

  def warp(x, y)
    x = @x
    y = @y
  end

  def walk_left
    @x -= 16
  end

  def walk_right
    @x += 16
  end

  def walk_up
    @y -= 16
  end

  def walk_down
    @y += 16
  end


  def draw
    @image.draw(@x, @y, 1)
  end
end
