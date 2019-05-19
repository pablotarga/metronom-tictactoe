require 'player_interface/base'

module PlayerInterface
  class Random < Base

    def pick(board)
      super(board)

      # randomly pick an available position
      board.available_positions.sample
    end

  end
end
