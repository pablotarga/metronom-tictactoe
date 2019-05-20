require 'spec_helper'

RSpec.describe PlayerInterface::Ai do
  let(:board){Board.new(3)}
  let(:player){Player.new('X', described_class)}
  subject{ player.interface }

  it_behaves_like 'a player interface'

  it('should pick a random position on first play'){
    expect_any_instance_of(Aux::MovePredictor::AvailablePosition).not_to receive(:best_move)
    expect(board).to receive(:available_positions).once.and_call_original
    player.pick(board)
  }

  it('should not use Aux::MovePredictor on first play'){
    expect(Aux::MovePredictor::AvailablePosition).not_to receive(:new)
    player.pick(board)
  }

  it('should use Aux::MovePredictor if already played'){
    board.set(0,0, player)
    expect_any_instance_of(Aux::MovePredictor::AvailablePosition).to receive(:best_move).once.and_call_original
    player.pick(board)
  }
end
