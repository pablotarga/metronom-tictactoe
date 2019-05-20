require 'yaml'
require 'game_loader'

begin
  game = GameLoader.load('config.yml', YAML)
  game.start!
rescue GameLoader::InvalidPlayerConfigError => e
  puts 'Players not configured properly'
  exit
end
