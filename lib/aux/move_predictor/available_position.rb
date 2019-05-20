module Aux
  module MovePredictor
    class AvailablePosition
      attr_reader :player, :board

      def initialize(player, board)
        @player = player
        @board = board.clone
      end

      def best_move
        my_move = best_range
        against = best_range(against:true)

        return random_move if my_move.nil? && against.nil?
        return against[:available_positions].sample if my_move.nil? && !against.nil?
        return my_move[:available_positions].sample if !my_move.nil? && against.nil?

        if my_move[:moves_left] < against[:moves_left]
          my_move[:available_positions].sample
        else
          against[:available_positions].sample
        end
      end

      private

      def best_range(against:false)
        player_ranges = board.get_all_ranges(position:true).select do |e|
          cell_players = e.values.compact.uniq
          is_player = cell_players.first == player
          cell_players.size == 1 && (against ? !is_player : is_player)
        end

        return nil if player_ranges.size == 0

        player_ranges.each_with_object({moves_left:board.size}) do |r, best|
          moves_left = r.values.count(nil)
          if best[:moves_left] > moves_left
            best[:moves_left] = moves_left
            best[:available_positions] = r.select{|k,v| v.nil?}.keys
          end
        end
      end

      def random_move
        board.available_positions.sample
      end
    end
  end
end
