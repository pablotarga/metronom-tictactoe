RSpec.describe PlayerInterface::Random do
  let(:board){Board.new(3)}
  let(:player){Player.new('X', described_class)}
  subject{ player.interface }

  it_behaves_like 'a player interface'

  it('should choose an available position'){expect(board.available_positions).to include subject.pick(board)}
  it('should choose randomly'){
    draw1 = subject.pick(board)
    draw2 = subject.pick(board)
    draw2 = subject.pick(board) if draw1 == draw2
    expect(draw1.join(',')).not_to be eql(draw2.join(','))
  }
end
