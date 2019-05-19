module PlayerInterface
  class Base
    class InvalidBoardError < ArgumentError
    end

    attr_reader :player
    def initialize(player)
      raise ArgumentError.new('player must be a Player') unless player.is_a?(Player)
      @player = player
    end

    def pick(board)
      raise InvalidBoardError unless board.is_a?(Board)
    end
  end
end
