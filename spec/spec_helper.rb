ENV['RACK_ENV'] = 'test'

require 'sinatra/activerecord'
require 'rspec'
require 'entity'
require 'pry'
require 'pg'
require 'shoulda-matchers'

RSpec.configure do |config|
  config.before(:each) do
    Entity.all.each do |player|
      player.destroy
    end
  end
  config.after(:each) do
    Entity.all.each do |player|
      player.destroy
    end
  end
end
