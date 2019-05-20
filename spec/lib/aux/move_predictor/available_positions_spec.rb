RSpec.describe Aux::MovePredictor::AvailablePosition do
  let(:board){ Board.new(3) }

  context 'initializing' do
    it('should clone board'){
      expect(board).to receive(:clone).at_least(:once).and_call_original
      described_class.new('X', board)
    }
  end

  context 'missing one cell to win' do
    it('should suggest missing cell on diagonal') do
      board.set(0,0,'X')
      board.set(2,2,'X')
      expect(described_class.new('X', board).best_move).to be_eql [1,1]
    end

    it('should suggest missing cell on same column') do
      board.set(1,1,'X')
      board.set(1,2,'X')
      expect(described_class.new('X', board).best_move).to be_eql [1,0]
    end

    it('should suggest missing cell on same row') do
      board.set(0,2,'X')
      board.set(1,2,'X')
      expect(described_class.new('X', board).best_move).to be_eql [2,2]
    end
  end

  context 'missing one cell to loose' do
    it('should suggest missing cell on diagonal') do
      board.set(0,0,'X')
      board.set(1,0,'O')
      board.set(2,2,'X')
      expect(described_class.new('O', board).best_move).to be_eql [1,1]
    end

    it('should suggest missing cell on same column') do
      board.set(1,1,'X')
      board.set(2,1,'O')
      board.set(1,2,'X')
      expect(described_class.new('O', board).best_move).to be_eql [1,0]
    end

    it('should suggest missing cell on same row') do
      board.set(0,2,'X')
      board.set(1,0,'O')
      board.set(1,2,'X')
      expect(described_class.new('O', board).best_move).to be_eql [2,2]
    end
  end


end
