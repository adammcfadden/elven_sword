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
BOSS_LEVEL = 3

class WorldWindow < Gosu::Window
  def initialize
### constants that will not change###
    super(BOARD_WIDTH*16, BOARD_HEIGHT*16, false) #map size
    self.caption = "Elven Sword!" #window title
    @exit_image = Gosu::Image.new(self, "./media/stairs_tile.png", false) # exit tile 1
    @player_image = Gosu::Image.new(self, "./media/player.png", false) # image tile 1
    # @player_attack_sound = Gosu::Sample.new(self, "media/fox_taunt.wav")
    # @monster_attack_sound = Gosu::Sample.new(self, "media/godzilla_roars.wav")
    # @player_flee_sound = Gosu::Sample.new(self, "media/fox_flee.wav")
    @font = Gosu::Font.new(self, Gosu::default_font_name, 24)
    @scaler = 16 #scales the size of the image tiles to account for image size
    @countdown = 0 #is used in #update to control player speed
    @level_counter = 1
    @heal_counter = 0
    @tile_selector = Random.new.rand(0..1)
### tile selector ###
    if @tile_selector == 0
      @floor_image = Gosu::Image.new(self, "./media/grass_tile.png", false) # image tile 1
      @floor_two_image = Gosu::Image.new(self, "./media/dirt_tile.png", false) # image tile 2
      @wall_image = Gosu::Image.new(self, "./media/pine_tree_tile.png", false) # image tile 2
      @wall_two_image = Gosu::Image.new(self, "./media/ocean.png", false)
    elsif @tile_selector == 1
      @floor_image = Gosu::Image.new(self, "./media/dirt_tile.png", false) # image tile 1
      @floor_two_image = Gosu::Image.new(self, "./media/dirt_tile.png", false) # image tile 2
      @wall_image = Gosu::Image.new(self, "./media/shrub_tile.png", false) # image tile 2
      @wall_two_image = Gosu::Image.new(self, "./media/ocean.png", false)
    end
###world/player generation###
    @floor = Floor.new({:width => BOARD_WIDTH, :height => BOARD_HEIGHT}) # call toby's mapmaker
    @floor.generate_map
    @wall_two = Floor.new({:width => BOARD_WIDTH, :height => BOARD_HEIGHT}) # call toby's mapmaker
    @wall_two.fill_map(true)
    steps = Random.new.rand(500..10000)
    @wall_two.drunk_walk(steps, false)
    @wall_two.cellular_automata_no_random(4)
    @entrance_and_exit = @floor.get_entrance_and_exit
    @entrance = @entrance_and_exit.fetch(:enter)
    @exit = @entrance_and_exit.fetch(:exit)
    @heart_image = Gosu::Image.new(self, "./media/heart.gif", false)
    @heart_x = 1
    @heart_y = 1

    @player = Entity.create(name: 'Dirge', vit: 10, in_battle?: false, str: 15, level: 1, xp: 0, health: 125,  location_x: @entrance.fetch(:x), location_y: @entrance.fetch(:y), pc?: true, image_path: 'media/player_tile.png', alive?: true, entity_drawn?: false)
    @weapon = Weapon.generate_random('dagger')
    @player.weapons.push(@weapon)
    @player_equipped_weapon = @player.weapons.first
    @entity_image = Gosu::Image.new(self, "#{@player.image_path}", false)
    @step_counter = 0
    @player_damage = -1
    @monster_damage = -1
    @screen = 'start'
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
### monster image ###
      @monster_image.draw(1400, 600, 1, scale_x = 1, scale_y = 1)
### player info box ###
      @font.draw("Name: #{@player.name}", 650, 60, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Level: #{@player.level}", 650, 80, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Health: #{@player.health}/#{@player.get_max_health}", 650, 100, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Strength: #{@player.str}", 650, 120, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Xp: #{@player.xp}/#{@player.level * 100}", 650, 140, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      if @player.weapons.first #player weapon
        @font.draw("Weapon: #{@player_equipped_weapon.name}", 650, 160, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      else
        @font.draw("Weapon: None", 650, 160, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      end
### monster info box ###
      @font.draw("Name: #{@monster.name}", 1015, 900, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Level: #{@monster.level}", 1015, 920, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Health: #{@monster.health}/#{@monster.get_max_health}", 1015, 940, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Strength: #{@monster.str}", 1015, 960, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Xp Given: #{@monster.level * 25}", 1015, 980, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      if @monster.weapons.first #monster weapon
        @font.draw("Weapon: #{@monster.weapons.last.name}", 1015, 1000, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      else
        @font.draw("Weapon: None", 1015, 1000, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
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
      if @battle.boss? && (button_down? Gosu::KbF or button_down? Gosu::GpButton2)
        draw_line(10, 675, 0xff_ff0000, 200, 675, 0xff_ff0000, z = 3, mode = :default)
        @font.draw("You cannot run from #{@monster.name}", 20, 700, 2, scale_x = 1.5, scale_y = 1.5, color = 0xff_ffffff)
      end

##### VICTORY #####

    elsif @screen == 'victory'
      draw_quad(1, 1, 0xff_000000, WIDTH, 1, 0xff_000000, WIDTH, HEIGHT, 0xff_000000, 1, HEIGHT, 0xff_000000, 0)
      @player_image.draw(20, 20, 1, scale_x = 1, scale_y = 1)
      @font.draw("Loot the body", 900, HEIGHT/2 - 100, 2, scale_x = 2, scale_y = 2, color = 0xff_ffffff)
      @font.draw("Equipping a Weapon will replace your current weapon", 900, HEIGHT/2 - 50, 2, scale_x = 0.8, scale_y = 0.8, color = 0xff_ffffff)
      if @monster.weapons.first #monster weapon
        @font.draw("Monster Weapon: #{@monster.weapons.first.name}", 900, HEIGHT/2, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        @font.draw("Category: #{@monster.weapons.first.category}", 900, HEIGHT/2 + 40, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        @font.draw("Name: #{@monster.weapons.first.name}", 900, HEIGHT/2 + 60, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        @font.draw("Damage: #{@monster.weapons.first.min_power} - #{@monster.weapons.first.max_power} dmg", 900, HEIGHT/2 + 80, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        @font.draw("E - Equip", 900, HEIGHT/2 + 100, 2, scale_x = 2, scale_y = 2, color = 0xff_ffffff)
      else
        @font.draw("No Loot Available", 900, HEIGHT/2, 2, scale_x = 2, scale_y = 2, color = 0xff_ffffff)
      end
      @font.draw("Current Weapon: #{@player_equipped_weapon.name}", 200, HEIGHT/2, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Category: #{@player_equipped_weapon.category}", 200, HEIGHT/2 + 40, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Name: #{@player_equipped_weapon.name}", 200, HEIGHT/2 + 60, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Damage: #{@player_equipped_weapon.min_power} - #{@player_equipped_weapon.max_power} dmg", 200, HEIGHT/2 + 80, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("R - Return to World", 600, HEIGHT/2 + 300, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      if @monster.alive? == false && @battle.boss?
        @font.draw("W - You Win! Exit Game.", 600, HEIGHT/2 + 400, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      end

##### LEVEL_UP #####

    elsif @screen == 'level_up'
      draw_quad(1, 1, 0xff_000000, WIDTH, 1, 0xff_000000, WIDTH, HEIGHT, 0xff_000000, 1, HEIGHT, 0xff_000000, 0)
      @player_image.draw(20, 20, 1, scale_x = 1, scale_y = 1)
      @font.draw("LEVEL UP!!", 700, HEIGHT/2 - 100, 2, scale_x = 2, scale_y = 2, color = 0xff_ffffff)
      @font.draw("Name: #{@player.name}", 700, HEIGHT/2 + 40, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Level: #{@player.level}", 700, HEIGHT/2 + 60, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Health: #{@player.health}/#{@player.get_max_health}", 700, HEIGHT/2 + 80, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Strength: #{@player.str}", 700, HEIGHT/2 + 100, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("Xp: #{@player.xp}/#{@player.level * 100}", 700, HEIGHT/2 + 120, 2, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("S - Search the body", 700, HEIGHT/2 + 180, 2, scale_x = 2, scale_y = 2, color = 0xff_ffffff)

##### START #####

    elsif @screen == 'start'
      draw_quad(1, 1, 0xff_000000, WIDTH, 1, 0xff_000000, WIDTH, HEIGHT, 0xff_000000, 1, HEIGHT, 0xff_000000, 0)
      @player_image.draw(20, 20, 1, scale_x = 1, scale_y = 1)
      @font.draw("Elven Sword", 700, HEIGHT/2, 2, scale_x = 5, scale_y = 5, color = 0xff_ffffff)
      @font.draw("S - Start", 700, HEIGHT/2 + 180, 2, scale_x = 2, scale_y = 2, color = 0xff_ffffff)

##### GAME_OVER #####

    elsif @screen == 'game_over'
      draw_quad(1, 1, 0xff_000000, WIDTH, 1, 0xff_000000, WIDTH, HEIGHT, 0xff_000000, 1, HEIGHT, 0xff_000000, 0)
      @font.draw("GAME OVER...", 700, HEIGHT/2, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)


##### WIN_GAME #####

    elsif @screen == 'win_game'
      draw_quad(1, 1, 0xff_000000, WIDTH, 1, 0xff_000000, WIDTH, HEIGHT, 0xff_000000, 1, HEIGHT, 0xff_000000, 0)
      @font.draw("YOU WIN...", 700, HEIGHT/2, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    else


##### WORLD #####
### Player info ###
      draw_quad(0, 0, 0x90_000000, 400, 0, 0x90_000000, 0, 100, 0x90_000000, 400, 100, 0x90_000000, 4)
      @font.draw("#{@player.name} Level: #{@player.level}", 10, 10, 5, scale_x = 0.80, scale_y = 0.80, color = 0xff_ffffff)
      @font.draw("Health: #{@player.health}/#{@player.get_max_health}", 10, 25, 5, scale_x = 0.80, scale_y = 0.80, color = 0xff_ffffff)
      @font.draw("Xp: #{@player.xp}/#{@player.level * 100}", 10, 40, 5, scale_x = 0.80, scale_y = 0.80, color = 0xff_ffffff)
      if @player_equipped_weapon
        @font.draw("Weapon: #{@player_equipped_weapon.name} - #{@player_equipped_weapon.min_power}-#{@player_equipped_weapon.max_power} dmg", 10, 55, 5, scale_x = 0.80, scale_y = 0.80, color = 0xff_ffffff)
      end
      @font.draw("Level: #{@level_counter}", 10, 80, 5, scale_x = 0.85, scale_y = 0.85, color = 0xff_ffffff)
### draws map ###
      @wall_two.map.each_index do |x|
        @wall_two.map[x].each_index do |y|
          unless(@wall_two.is_solid?(x, y))
            @wall_two_image.draw(x*@scaler, y*@scaler, 2)
          end
        end
      end
      @floor.map.each_index do |x|
        @floor.map[x].each_index do |y|
          if(@floor.is_solid?(x, y))
            @floor_two_image.draw(x*@scaler, y*@scaler, 0)
            @wall_image.draw(x*@scaler, y*@scaler, 1)
          else
            @floor_image.draw(x*@scaler, y*@scaler, 3)
          end
        end
      end
### draws player at entrance ###
      @entity_image.draw(@player.location_x*16, @player.location_y*16, 4)
### draws exit image ###
      @exit_image.draw(@exit.fetch(:x)*@scaler, @exit.fetch(:y)*@scaler, 4)
### draws hearts ###
      until @floor.is_solid?(@heart_x, @heart_y) == false
        @heart = @floor.pick_random_point
        @heart_x = @heart.fetch(:x)
        @heart_y = @heart.fetch(:y)
      end
      if @heal_counter == 0
        @heart_image.draw(@heart_x*@scaler, @heart_y*@scaler, 4)
      end
    end

##############################
      #UPDATE#
##############################
  def update

##### BATTLE #####

    if @screen == 'battle'
      if @countdown > 0 then
        @countdown -= 1
      end
      if (button_down? Gosu::KbA or button_down? Gosu::GpButton0) && @player.in_battle? && @monster.alive? && @player.alive? then
        if @countdown == 0
           @countdown = DELAY
           #@monster_attack_sound.play
           @monster_damage = @battle.attack(@player, @monster)
           @player_damage = @battle.attack(@monster, @player)
        end
      end
      if @battle.boss? != true
        if (button_down? Gosu::KbF or button_down? Gosu::GpButton2) && @battle.active? && @battle.active? then
           #@player_flee_sound.play
           @countdown = DELAY
           @player.flee
        end
      end
      if @player.in_battle? == false
        @screen = 'world' #flee screen shows dmg taken, and then press "key" to return to world
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
      if (button_down? Gosu::KbR or button_down? Gosu::GpButton0) then #lets player exit a battle, new if statement should exit when flee, monster health 0, etc.
        @player_damage = -1
        @monster_damage = -1
        @screen = 'world'
      end
      if (button_down? Gosu::KbW or button_down? Gosu::GpButton1) && @monster.alive? == false && @battle.boss?
        @screen = 'win_game'
      end
      if @monster.weapons.first
        if (button_down? Gosu::KbE or button_down? Gosu::GpButton2) then #let player equip monsters weapon
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


##### START #####

    elsif @screen == 'start'
      if (button_down? Gosu::KbS) or (button_down? Gosu::GpButton0) then #
        @screen = 'world'
      end

##### LEVEL_UP #####

    elsif @screen == 'level_up'
      if @player.xp != 0
        @player.level_up(6)
      end
      if (button_down? Gosu::KbS) or (button_down? Gosu::GpButton0) then #
        @screen = 'victory'
      end

##### WORLD #####
    else
      if @countdown > 0 then
         @countdown -= 1
      end
      if @player.location_y == @exit.fetch(:y) && @player.location_x == @exit.fetch(:x)
        @level_counter += 1
        @heal_counter = 0
        switch = 1
        if switch = 1
          @tile_selector = Random.new.rand(0..1)
        end
        switch = 0
        @floor = Floor.new({:width => BOARD_WIDTH, :height => BOARD_HEIGHT}) # call toby's mapmaker
        if @level_counter == BOSS_LEVEL - 1
          @floor_image = Gosu::Image.new(self, "./media/grass_tile.png", false) # image tile 1
          @floor_two_image = Gosu::Image.new(self, "./media/dirt_tile.png", false) # image tile 2
          @wall_image = Gosu::Image.new(self, "./media/pine_tree_tile.png", false) # image tile 2
          @wall_two_image = Gosu::Image.new(self, "./media/ocean.png", false)
          @exit_image = Gosu::Image.new(self, "./media/town_tile.png", false)
          @floor = Floor.new({:width => BOARD_WIDTH, :height => BOARD_HEIGHT}) # call toby's mapmaker
          @floor.generate_map
          @wall_two = Floor.new({:width => BOARD_WIDTH, :height => BOARD_HEIGHT}) # call toby's mapmaker
          @wall_two.fill_map(true)
          steps = Random.new.rand(500..10000)
          @wall_two.drunk_walk(steps, false)
          @wall_two.cellular_automata_no_random(4)
        elsif @level_counter == BOSS_LEVEL
          @floor.rogue_style
          @wall_two_image = Gosu::Image.new(self, "./media/castle_wall_tile.png", false)
          @floor_image = Gosu::Image.new(self, "./media/castle_floor_tile.png", false) # image tile 1
          @wall_image = Gosu::Image.new(self, "./media/castle_wall_tile.png", false) # image tile 2
          @exit_image = Gosu::Image.new(self, "./media/boss_tile.png", false) # exit tile 1
        elsif @level_counter > BOSS_LEVEL
          @monster = Battle.random_boss
          @monster_image = Gosu::Image.new(self, "#{@monster.image_path}", false)
          @battle = Battle.new(name: 'Battle!', boss?: true, active?: true)
          @player.enter_battle
          @screen = 'battle'
        else
          @floor.generate_map
        end
        entrance_and_exit = @floor.get_entrance_and_exit
        @entrance = entrance_and_exit.fetch(:enter)
        @exit = entrance_and_exit.fetch(:exit)
        @player.update(location_x: @entrance.fetch(:x), location_y: @entrance.fetch(:y))
      end
      if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
        if @countdown == 0
          @random_encounter_one = Random.new.rand(@step_counter..ENCOUNTER)
          @random_encounter_two = Random.new.rand(@step_counter..ENCOUNTER)
          if @random_encounter_one == @random_encounter_two
            @step_counter = 0
            @player.enter_battle
            @monster = Battle.random_monster  #should be in a method called on encounter
            while @monster.level > @player.level + 1 || @monster.level < @player.level - 3
              @monster = Battle.random_monster  #should be in a method called on encounter
            end
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
      if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
        if @countdown == 0
          @random_encounter_one = Random.new.rand(@step_counter..ENCOUNTER)
          @random_encounter_two = Random.new.rand(@step_counter..ENCOUNTER)
          if @random_encounter_one == @random_encounter_two
            @step_counter = 0
            @player.enter_battle
            @monster = Battle.random_monster  #should be in a method called on encounter
            while @monster.level > @player.level + 1 || @monster.level < @player.level - 3
              @monster = Battle.random_monster  #should be in a method called on encounter
            end
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
      if button_down? Gosu::KbUp or button_down? Gosu::GpUp then
        if @countdown == 0
          @random_encounter_one = Random.new.rand(@step_counter..ENCOUNTER)
          @random_encounter_two = Random.new.rand(@step_counter..ENCOUNTER)
          if @random_encounter_one == @random_encounter_two
            @step_counter = 0
            @player.enter_battle
            @monster = Battle.random_monster  #should be in a method called on encounter
            while @monster.level > @player.level + 1 || @monster.level < @player.level - 3
              @monster = Battle.random_monster  #should be in a method called on encounter
            end
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
      if button_down? Gosu::KbDown or button_down? Gosu::GpDown then
        if @countdown == 0
          @random_encounter_one = Random.new.rand(@step_counter..ENCOUNTER)
          @random_encounter_two = Random.new.rand(@step_counter..ENCOUNTER)
          if @random_encounter_one == @random_encounter_two
            @step_counter = 0
            @player.enter_battle
            @monster = Battle.random_monster  #should be in a method called on encounter
            while @monster.level > @player.level + 1 || @monster.level < @player.level - 3
              @monster = Battle.random_monster  #should be in a method called on encounter
            end
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
      if [@player.location_x, @player.location_y] == [@heart_x, @heart_y] && @heal_counter == 0
        if @player.health < @player.get_max_health
          @player.update(health: @player.get_max_health)
          @countdown += 30
          @heal_counter += 1
        end
      end
    end
  end
end
end
