class Player
  def initialize(window)
    @image = Gosu::Image.new(window, "media/fox.png", false)
    @width = 16
    @x = GameWindow::WIDTH/2
    @y = GameWindow::HEIGHT/2
  end

  def warp(x, y)
    x = @x
    y = @y
  end

  def walk_left
    unless @x == GameWindow::WIDTH - GameWindow::WIDTH + @width
      @x -= 16
    end
  end

  def walk_right
    unless @x == GameWindow::WIDTH - (2 * @width)
      @x += 16
    end
  end

  def walk_up
    unless @y == GameWindow::HEIGHT - GameWindow::HEIGHT + @width
      @y -= 16
    end
  end

  def walk_down
    unless @y == GameWindow::HEIGHT - (2 * @width)
      @y += 16
    end
  end


  def draw
    @image.draw(@x, @y, 1)
  end
end
