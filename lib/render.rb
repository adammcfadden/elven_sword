require 'gosu'
require './lib/floor'
require './lib/player'

WIDTH = 1280
HEIGHT = 1280

class GameWindow < Gosu::Window
  def initialize
    super(WIDTH, HEIGHT, false) #map size
    self.caption = "Render Map" #window title
    @floor_image = Gosu::Image.new(self, "./media/floor.png", false) # image tile 1
    @wall_image = Gosu::Image.new(self, "./media/wall.gif", false) # image tile 2
    @floor = Floor.new({:width => 80, :height => 80}) # call toby's mapmaker
    @floor.create_boundaries
    @scaler = 16 #scales the size of the image tiles to account for image size
    @player = Player.new(self)
  end

  def draw
    @player.draw
    @floor.map.each_index do |y|
      @floor.map[y].each_index do |x|
        if(@floor.is_solid?(x, y))
          @wall_image.draw(x*@scaler, y*@scaler, 0)
        else
          @floor_image.draw(x*@scaler, y*@scaler, 0)
        end
      end
    end
  end

  def update
    if button_down? Gosu::KbLeft then
      @player.walk_left
    end
    if button_down? Gosu::KbRight then
      @player.walk_right
    end
    if button_down? Gosu::KbUp then
      @player.walk_up
    end
    if button_down? Gosu::KbDown then
      @player.walk_down
    end
  end


end

window = GameWindow.new
window.show
