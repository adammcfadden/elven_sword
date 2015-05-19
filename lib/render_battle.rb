require 'gosu'
#require './lib/player'
#require './lib/battle'


WIDTH = 1280
HEIGHT = 1280

class BattleWindow < Gosu::Window
  def initialize
#   super(screen_width, screen_height, false)
    super(WIDTH, HEIGHT, false) #map size
    self.caption = "Fight!" #window title
    @player_image = Gosu::Image.new(self, "./media/baby_fox_mccloud.jpg", false) # image tile 1
    @vs_image = Gosu::Image.new(self, "./media/vs.png", false)
    @flee_image = Gosu::Image.new(self, "./media/fox_runs.gif", false)
    @attack_image = Gosu::Image.new(self, "./media/sword.png", false)
    @monster_image = Gosu::Image.new(self, "./media/baby_gojira.png", false) # image tile 2
    @player_attack_sound = Gosu::Sample.new(self, "media/fox_taunt.wav")
    @monster_attack_sound = Gosu::Sample.new(self, "media/godzilla_roars.wav")
    @player_flee_sound = Gosu::Sample.new(self, "media/fox_flee.wav")
    # @floor = Floor.new({:width => 80, :height => 80}) # call toby's mapmaker
    # @floor.create_boundaries
    # @player = Player.new(self)
  end


  def draw
    @player_image.draw(1, 1, 1)
    @vs_image.draw(650, 200, 1)
    @monster_image.draw(950, 175, 1)
    @attack_image.draw(1, 700, 2)
    @flee_image.draw(850, 700, 2)
    #display/refresh player health
    #display instructions
    #display/refresh player level
    #scale images properly
  end

  def update
    #while battle boolean
    if button_down? Gosu::KbLeft then
      self.attack
    end
    if button_down? Gosu::KbRight then
      self.flee
    end
    #end
  end

  def attack
    @player_attack_sound.play
    @monster_attack_sound.play
    #player.attack
    #return to attack
  end

  def flee
    @player_flee_sound.play
    #return to map view
    #trigger damage?
  end

end

window = BattleWindow.new
window.show
