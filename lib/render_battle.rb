require 'gosu'
#require './lib/player'
#require './lib/battle'


WIDTH = 1600
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
    @font = Gosu::Font.new(self, "Arial", 18)

    @player_health = 2
    @monster_health = 2
    @player_level = 1
    @monster_level = 1
    @player_xp = 3
    @monster_xp = 3
  end


  def draw
    @player_image.draw(100, 100, 1)
    @vs_image.draw(750, 300, 1)
    @monster_image.draw(1050, 275, 1)
    #@attack_image.draw(1, 700, 2)
    #@flee_image.draw(1050, 700, 2)

    @font.draw("HEALTH: #{@player_health}", 200, 800, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    @font.draw("  LEVEL: #{@player_level}", 200, 850, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    @font.draw("  LEVEL: #{@player_xp}", 200, 900, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)

    @font.draw("HEALTH: #{@monster_health}", 1100, 800, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    @font.draw("  LEVEL: #{@monster_level}", 1100, 850, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    @font.draw("  LEVEL: #{@monster_xp}", 1100, 900, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)

    @font.draw("(A)TTACK!", 150, 1000, 2, scale_x = 5, scale_y = 5, color = 0xff_ffffff)
    @font.draw("(F)LEE!", 1075, 1000, 2, scale_x = 5, scale_y = 5, color = 0xff_ffffff)

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
    #battle.attack(attacker,target)
    #return to attack
  end

  def flee
    @player_flee_sound.play
    #battle.flee
    #return to map view
    #trigger damage?
  end

end

window = BattleWindow.new
window.show
