require 'yaml'
require 'game_loader'

game = GameLoader.load('config.yml', YAML)
game.start!
