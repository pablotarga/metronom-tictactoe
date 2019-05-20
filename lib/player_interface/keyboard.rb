require 'player_interface/base'
require 'io/console'

module PlayerInterface
  class Keyboard < Base
    def pick(board)
      super(board)

      begin
        print "%s's turn: " % [player.symbol]
        col, row = gets.strip.split(',').map{|e| e.to_i-1} rescue []
        puts 'Position is invalid, please choose a position between 1 and %s for col,row respectively' % board.size if !board.valid?(col,row)
        puts 'Position is taken, please choose another'   if board.valid?(col,row) && !board.get(col,row).nil?
      rescue Interrupt
        puts "\n\nbreak again to exit, or press any key to continue...\n"
        a = STDIN.getch
        exit if a == "\x03"
        retry
      end until board.valid_and_available?(col, row)

      [col, row]
    end

  end
end
