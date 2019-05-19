require 'forwardable'

class Player
  extend Forwardable

  attr_reader :symbol, :interface

  def initialize(symbol, interface=PlayerInterface::Keyboard)
    @symbol = symbol
    @interface = interface.new(self)
  end

  def_delegators :interface, :pick
end
