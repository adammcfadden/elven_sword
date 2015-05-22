require 'gosu'
require 'sinatra/activerecord'
require './lib/render_world.rb'
require './lib/floor'
require './lib/entity'
require './lib/battle'
require './lib/weapon'
require 'pry'


window = WorldWindow.new
window.show
