RSpec.describe Board do
  subject{ Board.new(3) }

  context '#initialize(size_or_origin, printer=Aux::BoardPrinter)' do
    it('should not allow size less than 3') { expect{ Board.new(2) }.to raise_error(Board::InvalidSizeError)}
    it('should allow sizes between 3 and 10') do
      (3..10).each{|i| expect{ Board.new(i) }.not_to raise_error}
    end

    it('should not allow size more than 10') { expect{ Board.new(11) }.to raise_error(Board::InvalidSizeError)}

    context 'informing origin' do
      let(:origin){ Board.new(3) }
      before(:each){
        origin.set(0,0,'X')
        origin.set(1,1,'O')
      }
      subject{ Board.new(origin) }

      it('should have same size'){ expect(subject.size).to eq(origin.size) }
      it('should copy cells'){ expect(subject.cells.compact.size).not_to be eq(0) }
      it('should copy players'){ expect(subject.players).to match_array %w(X O) }
      it('should have a different reference for cells'){ expect(subject.cells.object_id).not_to eq(origin.cells.object_id) }
      it('should have a different reference for players'){ expect(subject.players.object_id).not_to eq(origin.players.object_id) }
      it('should not have any winner'){ expect(subject.winner).to be_nil }

      context 'having a winner' do
        before(:each){
          origin.set(0,1,'X')
          origin.set(0,2,'X')
        }
        subject{ Board.new(origin) }
        it('should have same winner as origin'){ expect(subject.winner).to be == origin.winner }
      end
    end
  end

  context 'winning a game' do
    before(:each) do
      subject.set(0,0,'X')
      subject.set(0,1,'X')
    end

    it{ expect{subject.set(0,2,'X')}.to change{subject.winner}.from(nil).to('X') }
    it{ expect{subject.set(0,2,'X')}.to change{subject.win?}.from(false).to(true) }
    it{ expect{subject.set(0,2,'X')}.to change{subject.game_over?}.from(false).to(true) }

    describe 'after last move' do
      before(:each){subject.set(0,2,'X')}

      it{ expect(subject).to be_win }
      it{ expect(subject).to be_game_over }
      it('should not allow any more moves'){ expect{subject.set(2,2,'O')}.to raise_error(Aux::Grid::InvalidMoveError) }
    end
  end

  context 'drawing a game' do
    before(:each) do
      subject.set(0,0,'X')
      subject.set(1,0,'O')
      subject.set(2,0,'X')
      subject.set(0,1,'X')
      subject.set(1,1,'O')
      subject.set(2,1,'X')
      subject.set(0,2,'O')
      subject.set(2,2,'O')
    end

    it{ expect{subject.set(1,2,'X')}.to change{subject.draw?}.from(false).to(true) }
    it{ expect{subject.set(1,2,'X')}.to change{subject.game_over?}.from(false).to(true) }
    it{ expect{subject.set(1,2,'X')}.not_to change{subject.win?} }
    it{ expect{subject.set(1,2,'X')}.not_to change{subject.winner} }

    context 'after last move' do
      before(:each){subject.set(1,2,'X')}

      it{ expect(subject).to be_draw }
      it{ expect(subject).to be_game_over }
      it('should have any available positions'){ expect(subject.available_positions.size).to be 0 }
    end
  end

end
