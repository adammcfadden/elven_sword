require 'gosu'
require './lib/floor'

class GameWindow < Gosu::Window
  def initialize
    super(400, 400, false) #map size
    self.caption = "Render Map" #window title
    @image = Gosu::Image.new(self, "./media/one.png", false) # image tile 1
    @image_2 = Gosu::Image.new(self, "./media/two.png", false) # image tile 2

    @floor = Floor.new({:width => 25, :height => 25}) # call toby's mapmaker
    @floor.create_boundaries 
    @scaler = 15 #scales the size of the image tiles to account for image size
  end

  def draw
    @floor.map.each_index do |y|
      @floor.map[y].each_index do |x|
        if(@floor.is_solid?(x, y))
          @image.draw(x*@scaler, y*@scaler, 1)
        else
          @image_2.draw(x*@scaler, y*@scaler, 1)
        end
      end
    end
  end

end

window = GameWindow.new
window.show
