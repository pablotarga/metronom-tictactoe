module Aux
  module MovePredictor
    class Minimax
      ALPHA_INF = -Float::INFINITY
      BETA_INF = Float::INFINITY
      attr_reader :player, :board

      def initialize(player, board)
        @player = player
        @board = board.clone
      end

      def best_move(depth:nil)
        depth ||= board.size

        playing_order = board.players.clone

        playing_order << player unless playing_order.include?(player)

        playing_order.rotate! until playing_order.first == player

        best_prediction = minimax(board, playing_order, depth:depth||board.size)
        best_prediction[:moves].first
      end

      private

      def minimax(board, playing_order, moves:[], depth:0, alpha:ALPHA_INF, beta:BETA_INF)
        return {score: (score(board, depth+1)), moves: moves} if depth == 0 || board.game_over?

        eval_player = playing_order[0]
        maxing = (eval_player == player)

        best = {score: maxing ? ALPHA_INF : BETA_INF}

        board.available_positions.each do |pos|
          _board = branch(board, eval_player, pos)

          result = minimax(_board, playing_order.rotate, moves: moves.clone.push(pos), depth:depth-1, alpha:alpha, beta:beta)
          best, alpha, beta = minimax_result(best, result, alpha, beta, maxing)

          break if beta <= alpha # prune
        end

        return best
      end

      def score(board, depth)
        return -1 if board.draw?
        return 10*depth if board.win? && board.winner == player
        return -10 if board.win? &&  board.winner != player

        # let other user with one move to finish is bad
        played_ranges = board.get_all_ranges.select{|e| e.any?{|i| !i.nil?} }
        single_player_ranges = played_ranges.select{|e| e.compact.uniq.size == 1}

        others_best_range = single_player_ranges.select{|e| e.compact.first != player}.min{|a,b| a.count(nil) <=> b.count(nil)}
        if others_best_range
          available_positions = others_best_range.count(nil)
          return -9 if available_positions == 1
          return -8 if available_positions == 2
        end

        my_best_range = single_player_ranges.select{|e| e.compact.first == player}.min{|a,b| a.count(nil) <=> b.count(nil)}
        if my_best_range
          available_positions = my_best_range.count(nil)
          return 8*depth if available_positions == 2
          return 9*depth if available_positions == 1
        end

        return 0
      end

      def minimax_result(best, result, alpha, beta, maxing)
        if maxing
          best, alpha = maximizing_result(best, result, alpha)
        else
          best, beta = minimizing_result(best, result, beta)
        end

        [best, alpha, beta]
      end

      def maximizing_result(best, result, alpha)
        best = [best, result].max{|a,b| a[:score] <=> b[:score] }
        alpha = [alpha, result[:score]].max

        [best, alpha]
      end

      def minimizing_result(best, result, beta)
        best = [best, result].min{|a,b| a[:score] <=> b[:score] }
        beta = [beta, result[:score]].min

        [best, beta]
      end

      def branch(board, player, pos)
        _board = board.clone
        _board.set(*pos, player)

        _board
      end
    end
  end
end
