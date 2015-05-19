require 'gosu'
require './lib/floor'
require './lib/player'

BOARD_WIDTH = 80
BOARD_HEIGHT = 80
TICKS_PER_STEP = 5

class GameWindow < Gosu::Window
  def initialize
    super(1280, 1280, false) #map size
    self.caption = "Render Map" #window title
    @floor_image = Gosu::Image.new(self, "./media/floor.png", false) # image tile 1
    @wall_image = Gosu::Image.new(self, "./media/wall.gif", false) # image tile 2
    @floor = Floor.new({:width => BOARD_WIDTH, :height => BOARD_HEIGHT}) # call toby's mapmaker
    @floor.fill_map(true)
    steps = 30000
    @floor.drunk_walk(steps ,false)
    @floor.create_boundaries
    @scaler = 16 #scales the size of the image tiles to account for image size
    @countdown = 0
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
    if @countdown > 0 then
      @countdown -= 1
    end
    if button_down? Gosu::KbLeft then
      unless @floor.is_solid?((@player.x - 1), @player.y)
        if @countdown == 0
          @countdown = TICKS_PER_STEP
          @player.walk_left
        end
      end
    end
    if button_down? Gosu::KbRight then
      unless @floor.is_solid?((@player.x + 1), @player.y)
        if @countdown == 0
          @countdown = TICKS_PER_STEP
          @player.walk_right
        end
      end
    end
    if button_down? Gosu::KbUp then
      unless @floor.is_solid?(@player.x, @player.y - 1)
        if @countdown == 0
          @countdown = TICKS_PER_STEP
          @player.walk_up
        end
      end
    end
    if button_down? Gosu::KbDown then
      unless @floor.is_solid?(@player.x, @player.y + 1)
        if @countdown == 0
          @countdown = TICKS_PER_STEP
          @player.walk_down
        end
      end
    end
  end
end

window = GameWindow.new
window.show
