module Aux
  class BoardPrinter

    attr_reader :board
    def initialize(board)
      @board = board
    end

    def print(center=0)
      l = ('-'*(3*board.size + board.size-1)).center(center)

      content = board.cells.each_slice(board.size).map do |row|
        row.map do |e|
          e = (e.is_a?(Player) ? e.symbol : e).to_s.center(3)
        end.join('|').center(center)
      end.join("\n%s\n" % l).center(center)

      puts "\n%s\n" % content
    end

  end
end
