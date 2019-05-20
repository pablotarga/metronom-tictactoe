require 'yaml'
require 'player_interface/ai'
require 'player_interface/keyboard'
require 'player_interface/random'
require 'player'
require 'game'

class GameLoader
  class InvalidPlayerConfigError < ArgumentError
  end

  # dictionary to translate config to PlayerInterface classes, will raise and ArgumentError if interface is not listed here
  INTERFACES = {
    ai: PlayerInterface::Ai,
    keyboard: PlayerInterface::Keyboard,
    random: PlayerInterface::Random
  }

  attr_reader :config

  # Input must be a file, path or string
  def initialize(input, parser=YAML)
    input = load_input(input)
    @config = parser.load(input)
  rescue Errno::ENOENT => e
    puts 'No such file `%s`' % input
    exit
  end

  def extract_config
    [config['size'].to_i, extract_players]
  end

  private

  def load_input(input)
    input = File.open(input, 'r') if input.is_a?(String) && File.exists?(input)
    input = input.read if input.respond_to?(:read)
    input
  end

  def extract_players
    raise InvalidPlayerConfigError.new('Players must be a key, value where key is the symbol and the value is the interface') unless config['players'].is_a?(Hash)
    config['players'].map do |symbol, interface|
      interface = interface.to_sym
      raise InvalidPlayerConfigError.new('Invalid PlayerInterface: `%s`' % interface) unless INTERFACES.include?(interface)

      Player.new(symbol, INTERFACES[interface])
    end
  end

  def self.load(input, parser)
    loader = new(input,parser)
    size, players = loader.extract_config

    Game.new(size, players)
  end

end
