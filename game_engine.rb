require 'gosu'
require './lib/render_world'
require './lib/render_battle'

while true#something is true
  if false#not in a battle
   window = WorldWindow.new
  else
   window = BattleWindow.new
  end
  window.show
end
