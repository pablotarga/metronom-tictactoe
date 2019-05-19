require 'forwardable'
require 'aux/board_printer'
require 'aux/grid'

class Board < Aux::Grid
  extend Forwardable
  def_delegators :@printer, :print

  class InvalidSizeError < ArgumentError
    def initialize(size)
      super('%sx%s is not an acceptable size. Board accepts sizes between 3 and 10' % [size, size])
    end
  end

  attr_reader :grid, :winner, :players

  def initialize(size_or_origin, printer=Aux::BoardPrinter)
    return clone_from(size_or_origin) if size_or_origin.is_a?(Board)
    raise ArgumentError.new("Value must be a Board or a Numeric") unless size_or_origin.is_a?(Numeric)
    raise InvalidSizeError.new(size_or_origin) unless size_or_origin.between?(3, 10)

    super(size_or_origin)
    @printer = printer.new(self)
    @winner = nil
    @players = []
  end

  def set(col, row, player)
    raise InvalidMoveError if game_over?
    super(col, row, player)
    append_player(player)
    check_winner(col, row)
  end

  def win?
    !@winner.nil?
  end

  def draw?
    @winner.nil? && !cells.any?(&:nil?)
  end

  def game_over?
    win? || draw?
  end

  def clone
    self.class.new(self)
  end

  private

  def clone_from(origin)
    super(origin)
    @winner   = origin.winner
    @players  = origin.players.clone
  end

  # Keep track of the players in play order
  def append_player(player)
    @players ||= []
    @players << player unless @players.include?(player)
  end

  # from a move (#set) check the col & row for a winning move
  def check_winner(col,row)
    return true if win?
    ranges = get_ranges_for(col, row)
    return true if ranges.any?{|range| is_winner_on_range?(range) }
    return false
  end

  # the winner is defined by having no other values on the range (rows, cols or diagonals)
  def is_winner_on_range?(range)
    return false unless range.uniq.size == 1 && !range.first.nil?

    @winner = range.first
    return true
  end

end
