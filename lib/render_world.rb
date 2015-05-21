require 'gosu'
require 'sinatra/activerecord'
require './lib/floor'
require './lib/entity'
require './lib/battle'
require './lib/weapon'
require 'pry'

WIDTH = 1600
HEIGHT = 1280
BOARD_WIDTH = 100
BOARD_HEIGHT = 80
TICKS_PER_STEP = 5
DELAY = 30
ENCOUNTER = 50 #lower for more encounters, higher for less

class WorldWindow < Gosu::Window
  def initialize
    super(BOARD_WIDTH*16, BOARD_HEIGHT*16, false) #map size
    self.caption = "Elven Sword!" #window title
    @floor_image = Gosu::Image.new(self, "./media/floor.png", false) # image tile 1
    @wall_image = Gosu::Image.new(self, "./media/wall.gif", false) # image tile 2
    @player_image = Gosu::Image.new(self, "./media/baby_fox_mccloud.jpg", false) # image tile 1
    @vs_image = Gosu::Image.new(self, "./media/vs.png", false)
    @monster_image = Gosu::Image.new(self, "./media/baby_gojira.png", false) # image tile 2
    @player_attack_sound = Gosu::Sample.new(self, "media/fox_taunt.wav")
    @monster_attack_sound = Gosu::Sample.new(self, "media/godzilla_roars.wav")
    @player_flee_sound = Gosu::Sample.new(self, "media/fox_flee.wav")
    @font = Gosu::Font.new(self, "Arial", 18)
    @floor = Floor.new({:width => BOARD_WIDTH, :height => BOARD_HEIGHT}) # call toby's mapmaker
    @floor.rogue_style
    @scaler = 16 #scales the size of the image tiles to account for image size
    @countdown = 0 #is used in #update to control player speed
    @player = Entity.create(name: 'Dirge', vit: 10, in_battle?: false, str: 15, level: 1, xp: 0, health: 125,  location_x: 1, location_y: 1, pc?: true, image_path: 'media/fox.png', alive?: true, entity_drawn?: false)
    @weapon = Weapon.generate_random('sword')
    @player.weapons.push(@weapon)
    @entity_image = Gosu::Image.new(self, "#{@player.image_path}", false)
    @step_counter = 0
    @screen = 'world'
    @player_damage = -1
    @monster_damage = -1
  end

  def draw
    if @screen == 'battle'
      draw_quad(1, 1, 0xffffffff, WIDTH, 1, 0xffffffff, WIDTH, HEIGHT, 0xffff0000, 1, HEIGHT, 0xffff0000, 0)
      @player_image.draw(150, 150, 1, scale_x = 0.75, scale_y = 0.75)
      @vs_image.draw(750, 300, 1)
      @monster_image.draw(1050, 175, 1, scale_x = 1.25, scale_y = 1.25)
      @font.draw("NAME: #{@player.name}", 150, 800, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      @font.draw("HEALTH: #{@player.health}", 200, 850, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      @font.draw("  LEVEL: #{@player.level}", 200, 900, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      @font.draw("     XP: #{@player.xp}", 200, 950, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      if @player.weapons.first #player weapon
        @font.draw("WEAPON: #{@player.weapons.first.name}", 200, 1000, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      else
        @font.draw("WEAPON: None", 200, 1000, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      end
      if @monster.weapons.first #monster weapon
        @font.draw("WEAPON: #{@monster.weapons.first.name}", 1100, 1000, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      else
        @font.draw("WEAPON: None", 1100, 1000, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      end
      @font.draw("NAME: #{@monster.name}", 1050, 800, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      @font.draw("HEALTH: #{@monster.health}", 1100, 850, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      @font.draw("  LEVEL: #{@monster.level}", 1100, 900, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      @font.draw("     XP: #{@monster.xp}", 1100, 950, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      if @countdown/60 > 0
        @font.draw("Chill #{@countdown/60} second(s)", 600, 950, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      end
      if @player_damage >= 0
        @font.draw("MONSTER ATTACKED FOR: #{@player_damage} DAMAGE", 450, 700, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      end
      if @monster_damage >= 0
        @font.draw("PLAYER ATTACKED FOR: #{@monster_damage} DAMAGE", 450, 750, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      end
      if @monster.alive? && @player.alive?
        @font.draw("ALIVE", 250, 1050, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
        @font.draw("ALIVE", 1150, 1050, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      end
      if !(@monster.alive?) && !(@player.alive?)
        @font.draw("Mutually Assured Destruction, Baby!", 450, 650, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
        @font.draw("DEAD", 250, 1050, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
        @font.draw("DEAD", 1150, 1050, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      end
      if !(@monster.alive?) && @player.alive?
        @font.draw("Total Monster DESTRUCTION!", 450, 650, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
        @font.draw("ALIVE", 250, 1050, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
        @font.draw("DEAD", 1150, 1050, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      end
      if !(@player.alive?) && @monster.alive?
        @font.draw("Adieu, mon ami!", 600, 625, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
        @font.draw("You have died.", 600, 725, 2, scale_x = 2, scale_y = 3, color = 0xff_ffffff)
        @font.draw("DEAD", 250, 1050, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
        @font.draw("ALIVE", 1150, 1050, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      end
      @font.draw(" (A)TTACK!", 150, 1150, 2, scale_x = 5, scale_y = 5, color = 0xff_ffffff)
      @font.draw(" (F)LEE!", 1075, 1150, 2, scale_x = 5, scale_y = 5, color = 0xff_ffffff)
    elsif @screen == 'victory'
      #victory screen player health. equipable loot, weapon stats. your weapon stats.
      @font.draw("PLayer Health: #{@player.health}", 450, 100, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      if @monster.weapons.first #monster weapon
        @font.draw("Monster Weapon: #{@monster.weapons.first.name}", 450, 300, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
        @font.draw("Category: #{@monster.weapons.first.category}", 450, 400, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
        @font.draw("Damage: #{@monster.weapons.first.min_power} - #{@monster.weapons.first.max_power}", 450, 500, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      end
      draw_quad(1, 1, 0xffffffff, WIDTH, 1, 0xffffffff, WIDTH, HEIGHT, 0xffff0000, 1, HEIGHT, 0xffff0000, 0)
      @font.draw("(R)eturn to World", 450, 700, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    elsif @screen == 'level_up'
      @font.draw("PLayer Health: #{@player.health}", 450, 100, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      @font.draw("PLayer Strength: #{@player.str}", 450, 200, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    else
      #HUD
      @font.draw("Level: #{@player.level}", 10, 10, 2, scale_x = 0.90, scale_y = 0.90, color = 0xff_ffffff)
      @font.draw("Health: #{@player.health}", 10, 25, 2, scale_x = 0.90, scale_y = 0.90, color = 0xff_ffffff)
      if @player.weapons.first
        @font.draw("Weapon: #{@player.weapons.first.name} - #{@player.weapons.first.min_power}-#{@player.weapons.first.max_power}", 10, 40, 2, scale_x = 0.90, scale_y = 0.90, color = 0xff_ffffff)
      end
      #@font.draw("Encounter Chance: #{}", 450, 100, 2, scale_x = 0.75, scale_y = 0.75, color = 0xff_ffffff)

      #draws map
      @floor.map.each_index do |x|
        @floor.map[x].each_index do |y|
          if(@floor.is_solid?(x, y))
            @wall_image.draw(x*@scaler, y*@scaler, 0)
          else
            @floor_image.draw(x*@scaler, y*@scaler, 0)
          end
        end
      end
      #draws player at random location that is not solid.
      until @player.entity_drawn? do
        unless @floor.is_solid?(@player.location_x, @player.location_y)
          @player.entity_is_drawn
        else
          @player.randomize_coords
        end
      end
      @entity_image.draw(@player.location_x*16, @player.location_y*16, 1)
    end

  def update
    if @screen == 'battle'
      if @countdown > 0 then
        @countdown -= 1
      end
      if (button_down? Gosu::KbA) && @player.in_battle? && @monster.alive? && @player.alive? then
        if @countdown == 0
           @countdown = DELAY
           @monster_attack_sound.play
           #@player_pre_health = @player.health
           #@monster_pre_health = @monster.health
           @monster_damage = @battle.attack(@player, @monster)
           @player_damage = @battle.attack(@monster, @player)
           #@player_post_health = @player.health
           #@monster_post_health = @monster.health
        end
      end
      if (button_down? Gosu::KbF) && @battle.active? then
         @player_flee_sound.play
         @countdown = DELAY
         @player.flee
      end
      if @player.in_battle? == false
        @screen = 'flee' #flee screen shows dmg taken, and then press "key" to return to world
      end
      if @monster.alive? == false && @player.alive?
        player_xp = @player.xp + @monster.level * 25
        @player.update(xp: player_xp)
        if @player.xp >= @player.level * 100
          @screen = 'level_up'
        else
          @screen = 'victory' #victory screen dmg done to player/monster. equipable loot, weapon stats. your weapon stats.
        end
      end
      if @player.alive? == false
        @screen = 'game_over' #game over screen.
      end
      # if !(@battle.active?) then
      #   @player.name = "QUITTER"
      #   @monster.name = "PROXY WINNER"
      # end
    elsif @screen == 'victory'
      if (button_down? Gosu::KbR) then #lets player exit a battle, new if statement should exit when flee, monster health 0, etc.
        @screen = 'world'
      end
    elsif @screen == 'level_up'
      if @player.xp != 0
        @player.level_up(6)
      end
      if (button_down? Gosu::KbR) then #lets player exit a battle, new if statement should exit when flee, monster health 0, etc.
        @screen = 'victory'
      end
    else
      if @countdown > 0 then
         @countdown -= 1
      end
      if button_down? Gosu::KbLeft then
        if @countdown == 0
          @random_encounter_one = Random.new.rand(@step_counter..ENCOUNTER)
          @random_encounter_two = Random.new.rand(@step_counter..ENCOUNTER)
        end
        if @random_encounter_one == @random_encounter_two
          @player.enter_battle
          @screen = 'battle'
          @step_counter = 0
          @monster = Battle.random_monster  #should be in a method called on encounter
          @battle = Battle.new(name: 'Battle!', boss?: false, active?: true)  #should be in a method called on encounter
        end
        unless @floor.is_solid?((@player.location_x - 1), @player.location_y)
          if @countdown == 0
            @countdown = TICKS_PER_STEP
            @step_counter += 1
            @player.move_west
          end
        end
      end
      if button_down? Gosu::KbRight then
        if @countdown == 0
          @random_encounter_one = Random.new.rand(@step_counter..ENCOUNTER)
          @random_encounter_two = Random.new.rand(@step_counter..ENCOUNTER)
        end
        if @random_encounter_one == @random_encounter_two
          @player.enter_battle
          @screen = 'battle'
          @step_counter = 0
          @monster = Battle.random_monster  #should be in a method called on encounter
          @battle = Battle.new(name: 'Battle!', boss?: false, active?: true)  #should be in a method called on encounter
        end
        unless @floor.is_solid?((@player.location_x + 1), @player.location_y)
          if @countdown == 0
            @countdown = TICKS_PER_STEP
            @player.move_east
            @step_counter += 1
          end
        end
      end
      if button_down? Gosu::KbUp then
        if @countdown == 0
          @random_encounter_one = Random.new.rand(@step_counter..ENCOUNTER)
          @random_encounter_two = Random.new.rand(@step_counter..ENCOUNTER)
        end
        if @random_encounter_one == @random_encounter_two
          @player.enter_battle
          @screen = 'battle'
          @step_counter = 0
          @monster = Battle.random_monster  #should be in a method called on encounter
          @battle = Battle.new(name: 'Battle!', boss?: false, active?: true)  #should be in a method called on encounter
        end
        unless @floor.is_solid?(@player.location_x, @player.location_y - 1)
          if @countdown == 0
            @countdown = TICKS_PER_STEP
            @player.move_north
            @step_counter += 1
          end
        end
      end
      if button_down? Gosu::KbDown then
        if @countdown == 0
          @random_encounter_one = Random.new.rand(@step_counter..ENCOUNTER)
          @random_encounter_two = Random.new.rand(@step_counter..ENCOUNTER)
        end
        if @random_encounter_one == @random_encounter_two
          @player.enter_battle
          @screen = 'battle'
          @step_counter = 0
          @monster = Battle.random_monster  #should be in a method called on encounter
          @battle = Battle.new(name: 'Battle!', boss?: false, active?: true)  #should be in a method called on encounter
        end
        unless @floor.is_solid?(@player.location_x, @player.location_y + 1)
          if @countdown == 0
            @countdown = TICKS_PER_STEP
            @player.move_south
            @step_counter += 1
          end
        end
      end
    end
    end
  end
  window = WorldWindow.new
  window.show
end
