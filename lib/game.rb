class Game < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Ruby in the Rough"

  #find a way to make @SKEI  @background_image = Gosu::Image.new(self, "media/Space.png", true)

    @player = Player.new(self)
    @player.warp(320, 240)
  end
