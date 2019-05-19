require 'player_interface/base'
require 'aux/move_predictor'

module PlayerInterface
  class Ai < Base

    def pick(board)
      super(board)
      if board.players.include?(player)
        Aux::MovePredictor.new(player, board).best_move(depth: 3)
      else
        board.available_positions.sample
      end
    end

  end
end
