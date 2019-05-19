require 'board'
require 'player_interface/keyboard'
require 'player_interface/ai'
require 'game_loader'

class Game
  attr_reader :board, :players

  def initialize(size, players)
    @board = Board.new(size)
    @players = players
  end

  def start!
    puts "= LETS PLAY TIC-TAC-TOE =="
    print_rules

    board.cells.size.times do |i|
      break if board.game_over?

      board.print

      player = players[i % players.size]
      col,row = player.pick(board)
      board.set(col, row, player)
    end

    print_result
  end

  def print_rules
    _rules = [
      'Each player on their turn will pick one cell to make a move.',
      'Once a player pick a cell that cell cannot be picked again.',
      'The game is draw, when runs out of available cells and there is no winner.',
      'Once a player fills all the cells on any row, column or diagonal that player is the winner.',
    ]

    if players.any?{|p| p.interface.is_a?(PlayerInterface::Keyboard)}
      _rules << "\nKEYBOARD:"
      _rules << "  Please inform the column and row with a comma between the values"
      _rules << "  e.g. 3rd column and first row would be respectively represented by 3,1\n"
      _rules << "  You can use values between 1 and %s for column/row input" % (board.size)
      _rules << "\n  To exit you can use ctrl+c/cmd+c"
    end

    if players.any?{|p| p.interface.is_a?(PlayerInterface::Ai)}
      _rules << "\nAI:"
      _rules << '  AI would try to figure which move would be the most eficient'
      _rules << '  It is using minimax algorithm with pruning and basic score checkings'
      _rules << '  This decision is made automatically and do not need human intervention'
    end

    puts "\nRULES"
    puts _rules.join("\n")
  end

  def print_result
    puts "\n"
    puts 'GAME OVER'
    if board.win?
      puts 'Player %s is the winner!' % board.winner.symbol
    else
      puts 'DRAW'
    end
    board.print
  end

  private

  def self.load_config(*args)
    new *GameLoader.new(*args).extract_config
  end

end
