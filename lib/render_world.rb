require 'gosu'
require 'sinatra/activerecord'
require './lib/floor'
require './lib/entity'
require './lib/battle'
require './lib/weapon'
require 'pry'

WIDTH = 1920
HEIGHT = 1080
BOARD_WIDTH = 120
BOARD_HEIGHT = 67
TICKS_PER_STEP = 5
DELAY = 30
ENCOUNTER = 150 #lower for more encounters, higher for less

class WorldWindow < Gosu::Window
  def initialize
    super(BOARD_WIDTH*16, BOARD_HEIGHT*16, false) #map size
    self.caption = "Elven Sword!" #window title
    @floor_image = Gosu::Image.new(self, "./media/grass_tile.png", false) # image tile 1
    @wall_image = Gosu::Image.new(self, "./media/stump_tile.png", false) # image tile 2
    @player_image = Gosu::Image.new(self, "./media/player.png", false) # image tile 1
    @vs_image = Gosu::Image.new(self, "./media/vs.png", false)
    @monster_image = Gosu::Image.new(self, "./media/baby_gojira.png", false) # image tile 2
    @player_attack_sound = Gosu::Sample.new(self, "media/fox_taunt.wav")
    @monster_attack_sound = Gosu::Sample.new(self, "media/godzilla_roars.wav")
    @player_flee_sound = Gosu::Sample.new(self, "media/fox_flee.wav")
    @font = Gosu::Font.new(self, "Arial", 24)
    @floor = Floor.new({:width => BOARD_WIDTH, :height => BOARD_HEIGHT}) # call toby's mapmaker
    @floor.generate_map
    entrance_and_exit = @floor.get_entrance_and_exit
    @entrance = entrance_and_exit.fetch(:enter)
    @exit = entrance_and_exit.fetch(:exit)
    @scaler = 16 #scales the size of the image tiles to account for image size
    @countdown = 0 #is used in #update to control player speed
    @player = Entity.create(name: 'Dirge', vit: 10, in_battle?: false, str: 15, level: 1, xp: 0, health: 125,  location_x: @entrance.fetch(:x), location_y: @entrance.fetch(:y), pc?: true, image_path: 'media/player_tile.png', alive?: true, entity_drawn?: false)
    @weapon = Weapon.generate_random('dagger')
    @player.weapons.push(@weapon)
    @player_equipped_weapon = @player.weapons.first
    @entity_image = Gosu::Image.new(self, "#{@player.image_path}", false)
    @step_counter = 0
    @player_damage = -1
    @monster_damage = -1
  end

  def draw

##### BATTLE #####
    if @screen == 'battle'
### background ###
      draw_quad(1, 1, 0xff_000000, WIDTH, 1, 0xff_000000, WIDTH, HEIGHT, 0xff_000000, 1, HEIGHT, 0xff_000000, 0)
### player image ###
      @player_image.draw(20, 20, 1, scale_x = 1, scale_y = 1)
### vs slash ###
      draw_line(0, HEIGHT, 0xff_ff0000, WIDTH, 0, 0xff_ff0000, z = 1, mode = :default)
      draw_quad(WIDTH/2 - 262, HEIGHT/2 - 150, 0xff_000000, WIDTH/2 + 210, HEIGHT/2 - 150, 0xff_000000, WIDTH/2 - 262, HEIGHT/2 + 150, 0xff_000000, WIDTH/2 + 210, HEIGHT/2 + 150, 0xff_000000, 2)
      @font.draw("VS", WIDTH/2 - 70, HEIGHT/2 - 15, 3, scale_x = 3, scale_y = 3, color = 0xff_ff0000)
      #@vs_image.draw(750, 300, 1)
### monster image ###
      @monster_image.draw(1400, 600, 1, scale_x = 1, scale_y = 1)
### player info box ###
      @font.draw("Name: #{@player.name}", 650, 60, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Level: #{@player.level}", 650, 80, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Health: #{@player.health}/#{@player.get_max_health}", 650, 100, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Xp: #{@player.xp}/#{@player.level * 100}", 650, 120, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      if @player.weapons.first #player weapon
        @font.draw("Weapon: #{@player_equipped_weapon.name}", 650, 140, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      else
        @font.draw("Weapon: None", 650, 140, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      end
### monster info box ###
      @font.draw("Name: #{@monster.name}", 1015, 900, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Health: #{@monster.health}/#{@monster.get_max_health}", 1015, 920, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Level: #{@monster.level}", 1015, 940, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Xp: #{@monster.xp}", 1015, 960, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      if @monster.weapons.first #monster weapon
        @font.draw("Weapon: #{@monster.weapons.last.name}", 1015, 980, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      else
        @font.draw("Weapon: None", 1015, 980, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      end
### notifications ###
      if @countdown/60 > 0
        @font.draw("Chill #{@countdown/60} second(s)", 600, 950, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      end
      if @player_damage >= 0
        @font.draw("#{@monster.name} dealt: #{@player_damage} damage", WIDTH/2 - 140, HEIGHT/2 + 55, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      end
      if @monster_damage >= 0
        @font.draw("#{@player.name} dealt: #{@monster_damage} damage", WIDTH/2 - 140, HEIGHT/2 - 45, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      end
      @font.draw("A - Attack!", 20, 600, 2, scale_x = 1.5, scale_y = 1.5, color = 0xff_ffffff)
      @font.draw("F - Flee!", 20, 650, 2, scale_x = 1.5, scale_y = 1.5, color = 0xff_ffffff)

##### VICTORY #####

    elsif @screen == 'victory'
      #victory screen player health. equipable loot, weapon stats. your weapon stats.
      @font.draw("PLayer Health: #{@player.health}", 450, 100, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      if @monster.weapons.first #monster weapon
        @font.draw("(E)quip", 450, 600, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
        @font.draw("Monster Weapon: #{@monster.weapons.first.name}", 450, 300, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
        @font.draw("Category: #{@monster.weapons.first.category}", 450, 400, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
        @font.draw("Damage: #{@monster.weapons.first.min_power} - #{@monster.weapons.first.max_power}", 450, 500, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      end
      draw_quad(1, 1, 0xff_808080, WIDTH, 1, 0xff_808080, WIDTH, HEIGHT, 0xff_808080, 1, HEIGHT, 0xff_808080, 0)
      @font.draw("(R)eturn to World", 450, 700, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)

##### LEVEL_UP #####

    elsif @screen == 'level_up'
      @font.draw("PLayer Health: #{@player.health}", 450, 100, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      @font.draw("PLayer Strength: #{@player.str}", 450, 200, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)

##### WORLD #####

    else
###HUD###
      draw_quad(0, 0, 0x80000000, 180, 0, 0x30000000, 0, 60, 0x80000000, 180, 60, 0x30000000, 1)
      @font.draw("Level: #{@player.level}", 10, 10, 2, scale_x = 0.70, scale_y = 0.70, color = 0xff_ffffff)
      @font.draw("Health: #{@player.health}", 10, 25, 2, scale_x = 0.70, scale_y = 0.70, color = 0xff_ffffff)
      if @player_equipped_weapon
        @font.draw("Weapon: #{@player_equipped_weapon.name} - #{@player_equipped_weapon.min_power}-#{@player_equipped_weapon.max_power}", 10, 40, 2, scale_x = 0.70, scale_y = 0.70, color = 0xff_ffffff)
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

##### BATTLE #####

    if @screen == 'battle'
      if @countdown > 0 then
        @countdown -= 1
      end
      if (button_down? Gosu::KbA) && @player.in_battle? && @monster.alive? && @player.alive? then
        if @countdown == 0
           @countdown = DELAY
           #@monster_attack_sound.play
           #@player_pre_health = @player.health
           #@monster_pre_health = @monster.health
           @monster_damage = @battle.attack(@player, @monster)
           @player_damage = @battle.attack(@monster, @player)
           #@player_post_health = @player.health
           #@monster_post_health = @monster.health
        end
      end
      if (button_down? Gosu::KbF) && @battle.active? then
         #@player_flee_sound.play
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

##### VICTORY #####

    elsif @screen == 'victory'
      if (button_down? Gosu::KbR) then #lets player exit a battle, new if statement should exit when flee, monster health 0, etc.
        @screen = 'world'
      end
      if @monster.weapons.first
        if (button_down? Gosu::KbE) then #let player equip monsters weapon
          @player.weapons.each do |weapon|
            weapon.unequip
          end
          @monster.weapons.first.equip
          @player.weapons.push(@monster.weapons.first)
          @player.weapons.each do |weapon|
            if weapon.isequipped?
              @player_equipped_weapon = weapon
            end
          end
        end
      end

##### LEVEL_UP #####

    elsif @screen == 'level_up'
      if @player.xp != 0
        @player.level_up(6)
      end
      if (button_down? Gosu::KbT) then #
        @screen = 'victory'
      end

##### WORLD #####

    else
      if @countdown > 0 then
         @countdown -= 1
      end
      if button_down? Gosu::KbLeft then
        if @countdown == 0
          @random_encounter_one = Random.new.rand(@step_counter..ENCOUNTER)
          @random_encounter_two = Random.new.rand(@step_counter..ENCOUNTER)
          if @random_encounter_one == @random_encounter_two
            @step_counter = 0
            @player.enter_battle
            @monster = Battle.random_monster  #should be in a method called on encounter
            @monster_image = Gosu::Image.new(self, "#{@monster.image_path}", false)
            @battle = Battle.new(name: 'Battle!', boss?: false, active?: true)  #should be in a method called on encounter
            @screen = 'battle'
          end
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
          if @random_encounter_one == @random_encounter_two
            @step_counter = 0
            @player.enter_battle
            @monster = Battle.random_monster  #should be in a method called on encounter
            @monster_image = Gosu::Image.new(self, "#{@monster.image_path}", false)
            @battle = Battle.new(name: 'Battle!', boss?: false, active?: true)  #should be in a method called on encounter
            @screen = 'battle'
          end
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
          if @random_encounter_one == @random_encounter_two
            @step_counter = 0
            @player.enter_battle
            @monster = Battle.random_monster  #should be in a method called on encounter
            @monster_image = Gosu::Image.new(self, "#{@monster.image_path}", false)
            @battle = Battle.new(name: 'Battle!', boss?: false, active?: true)  #should be in a method called on encounter
            @screen = 'battle'
          end
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
          if @random_encounter_one == @random_encounter_two
            @step_counter = 0
            @player.enter_battle
            @monster = Battle.random_monster  #should be in a method called on encounter
            @monster_image = Gosu::Image.new(self, "#{@monster.image_path}", false)
            @battle = Battle.new(name: 'Battle!', boss?: false, active?: true)  #should be in a method called on encounter
            @screen = 'battle'
          end
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
