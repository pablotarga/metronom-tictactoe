RSpec.describe Aux::MovePredictor do
  let(:board){ Board.new(3) }

  context 'initializing' do
    it('should clone board'){
      expect(board).to receive(:clone).at_least(:once).and_call_original
      Aux::MovePredictor.new('X', board)
    }
  end

  context 'missing one cell to win' do
    it('should suggest missing cell on diagonal') do
      board.set(0,0,'X')
      board.set(2,2,'X')
      expect(Aux::MovePredictor.new('X', board).best_move(depth:1)).to be_eql [1,1]
    end

    it('should suggest missing cell on same column') do
      board.set(1,1,'X')
      board.set(1,2,'X')
      expect(Aux::MovePredictor.new('X', board).best_move(depth:1)).to be_eql [1,0]
    end

    it('should suggest missing cell on same row') do
      board.set(0,2,'X')
      board.set(1,2,'X')
      expect(Aux::MovePredictor.new('X', board).best_move(depth:1)).to be_eql [2,2]
    end

    context 'with more than 1 depth level to spare' do
      it('should suggest missing cell on diagonal') do
        board.set(0,0,'X')
        board.set(2,2,'X')
        expect(Aux::MovePredictor.new('X', board).best_move(depth:2)).to be_eql [1,1]
      end

      it('should suggest missing cell on diagonal') do
        board.set(0,0,'X')
        board.set(2,2,'X')
        expect(Aux::MovePredictor.new('X', board).best_move(depth:3)).to be_eql [1,1]
      end

      it('should suggest missing cell on diagonal') do
        board.set(0,0,'X')
        board.set(2,2,'X')
        expect(Aux::MovePredictor.new('X', board).best_move(depth:4)).to be_eql [1,1]
      end
    end
  end

  context 'missing one cell to loose' do
    it('should suggest missing cell on diagonal') do
      board.set(0,0,'X')
      board.set(1,0,'O')
      board.set(2,2,'X')
      expect(Aux::MovePredictor.new('O', board).best_move(depth:1)).to be_eql [1,1]
    end

    it('should suggest missing cell on same column') do
      board.set(1,1,'X')
      board.set(2,1,'O')
      board.set(1,2,'X')
      expect(Aux::MovePredictor.new('O', board).best_move(depth:1)).to be_eql [1,0]
    end

    it('should suggest missing cell on same row') do
      board.set(0,2,'X')
      board.set(1,0,'O')
      board.set(1,2,'X')
      expect(Aux::MovePredictor.new('O', board).best_move(depth:1)).to be_eql [2,2]
    end

    context 'with more than 1 depth level to spare' do
      it('should suggest missing cell on diagonal') do
        board.set(0,0,'X')
        board.set(1,0,'O')
        board.set(2,2,'X')
        expect(Aux::MovePredictor.new('O', board).best_move(depth:2)).to be_eql [1,1]
      end

      it('should suggest missing cell on diagonal') do
        board.set(0,0,'X')
        board.set(1,0,'O')
        board.set(2,2,'X')
        expect(Aux::MovePredictor.new('O', board).best_move(depth:3)).to be_eql [1,1]
      end

      it('should suggest missing cell on diagonal') do
        board.set(0,0,'X')
        board.set(1,0,'O')
        board.set(2,2,'X')
        expect(Aux::MovePredictor.new('O', board).best_move(depth:4)).to be_eql [1,1]
      end
    end
  end


end
