require 'player_interface/base'
require 'aux/move_predictor/available_position'

module PlayerInterface
  class Ai < Base

    def pick(board)
      super(board)
      if board.players.include?(player)
        Aux::MovePredictor::AvailablePosition.new(player, board).best_move
      else
        board.available_positions.sample
      end
    end

  end
end
