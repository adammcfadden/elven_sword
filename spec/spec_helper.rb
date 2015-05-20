ENV['RACK_ENV'] = 'test'

require 'sinatra/activerecord'
require 'rspec'
require 'entity'
require 'battle'
require 'weapon'
require 'weapon'
require 'pry'
require 'pg'

require 'shoulda-matchers'

RSpec.configure do |config|
  config.before(:each) do
    Entity.all.each do |entity|
      entity.destroy
    Battle.all.each do |battle|
      battle.destroy
    end
  end
  config.after(:each) do
    Entity.all.each do |entity|
      entity.destroy
    end
    Battle.all.each do |battle|
      battle.destroy
    end
    end
  end
end
