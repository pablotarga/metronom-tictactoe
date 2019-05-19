RSpec.describe Aux::Grid do
  subject{ Aux::Grid.new(3) }

  it('should create new grid') { should be_truthy }

  describe '#initializer' do
    it('should not concern about small sizes') { expect{Aux::Grid.new(1)}.to_not raise_error }
    it('should not concern about big sizes') { expect{Aux::Grid.new(100)}.to_not raise_error }
    it('should not allow size 0') { expect{Aux::Grid.new(0)}.to raise_error(ArgumentError) }
    it('should not allow negative sizes') { expect{Aux::Grid.new(-1)}.to raise_error(ArgumentError) }

    context 'not numeric size' do
      it('should reject nil as size') { expect{Aux::Grid.new(nil)}.to raise_error(ArgumentError) }
      it('should reject string as size') { expect{Aux::Grid.new('big')}.to raise_error(ArgumentError) }
      it('should reject symbols as size') { expect{Aux::Grid.new(:big)}.to raise_error(ArgumentError) }
    end
  end

  describe '#get(col,row)' do
    it('should not raise error on valid position'){ expect{ subject.get(1,1) }.to_not raise_error }
    it('should retrieve the content of position') do
      expect(subject).to receive(:cells).at_least(:once){ [nil,nil,nil,nil,'X',nil,nil,nil,nil] }
      expect(subject.get(1,1)).to be_eql 'X'
    end

    context 'invalid position' do
      it('should raise error if column is greater than size'){ expect{ subject.get(3,1) }.to raise_error(Aux::Grid::InvalidCellError) }
      it('should raise error if row is greater than size'){ expect{ subject.get(1,3) }.to raise_error(Aux::Grid::InvalidCellError) }
      it('should raise error even if calc is valid position'){ expect{ subject.get(3,0) }.to raise_error(Aux::Grid::InvalidCellError) }
    end
  end

  describe '#set(col,row,value)' do
    it('should set a valid position'){ expect{ subject.set(1,1,1) }.to_not raise_error }
    it('should change position value'){ expect{ subject.set(1,1,1) }.to change{subject.get(1,1)}.from(nil).to(1) }
    it('should raise InvalidMoveError if cell is taken') do
      subject.cells[4] = 'X'
      expect{subject.set(1,1,'O') }.to raise_error(Aux::Grid::InvalidMoveError)
    end

    context 'invalid position' do
      it('should raise error if column is greater than size'){ expect{ subject.set(3,1,'X') }.to raise_error(Aux::Grid::InvalidCellError) }
      it('should raise error if row is greater than size'){ expect{ subject.set(1,3,'X') }.to raise_error(Aux::Grid::InvalidCellError) }
      it('should raise error even if calc is valid position'){ expect{ subject.set(3,0,'X') }.to raise_error(Aux::Grid::InvalidCellError) }
    end
  end

  describe '#valid?(col, row)' do
    it('should be valid on 0x0'){ expect(subject.valid?(0,0)).to be_truthy }
    it('should be valid on 2x0'){ expect(subject.valid?(2,0)).to be_truthy }
    it('should not be valid on 3x0'){ expect(subject.valid?(3,0)).not_to be_truthy }
    it('should not be valid on -1x0'){ expect(subject.valid?(-1,0)).not_to be_truthy }
    it('should not be valid on \'a\'x0'){ expect(subject.valid?('a',0)).not_to be_truthy }
  end

  describe '#available_positions' do
    it { expect(subject.available_positions.first).to be_a Array }
    it("should return valid positions") {
      pos = subject.available_positions.sample
      expect(subject.valid?(*pos)).to be_truthy
    }
    context 'blank board' do
      it('should return all positions') { expect(subject.available_positions.size).to eq(subject.cells.size) }
    end

    context 'with one position filled' do
      before(:each){ subject.cells[0] = 'X' }
      it { expect(subject.available_positions.size).to eq(subject.cells.size - 1) }
      it { expect(subject.available_positions).not_to include [0,0] }
    end

    context 'with two positions filled' do
      before(:each) do
        subject.cells[0] = 'X'
        subject.cells[1] = 'X'
      end
      it { expect(subject.available_positions.size).to eq(subject.cells.size - 2) }
      it { expect(subject.available_positions).not_to include [[0,0],[0,1]]}
    end

    context 'only one left' do
      before(:each) do
        (0...subject.cells.size-1).each{|i| subject.cells[i] = 'X'}
      end

      it { expect(subject.available_positions.size).to eq(1) }
      it { expect(subject.available_positions).to include [2,2]}
    end
  end

  describe '#is_diag1?(col,row)' do
    let(:valid){ [[0,0], [1,1], [2,2]] }
    let(:others){ [0,1,2].product([0,1,2]) - valid }

    it('should be truthy on 0x0, 1x1 and 2x2'){
      expect(valid.all?{|pos| subject.is_diag1?(*pos) }).to be_truthy
    }

    it('should have 6 not diag1 positions ') { expect(others.size).to be 6}
    it('should not be truthy on any other') {
      expect(others.any?{|pos| subject.is_diag1?(*pos)}).not_to be_truthy
    }

  end

  describe '#is_diag2?(col,row)' do
    let(:valid){ [[0,2], [1,1], [2,0]] }
    let(:others){ [0,1,2].product([0,1,2]) - valid }

    it('should be truthy on 0x2, 1x1 and 2x0'){
      expect(valid.all?{|pos| subject.is_diag2?(*pos) }).to be_truthy
    }

    it('should have 6 not diag2 positions ') { expect(others.size).to be 6}
    it('should not be truthy on any other') {
      expect(others.any?{|pos| subject.is_diag2?(*pos)}).not_to be_truthy
    }

    context 'on an 4x4 grid' do
      subject{ described_class.new(4) }

      let(:valid){ [[0,3], [1,2], [2,1], [3,0]] }
      let(:others){ [0,1,2,3].product([0,1,2,3]) - valid }

      it('should be truthy on 0x3, 1x2, 2x1 and 3x0'){
        expect(valid.all?{|pos| subject.is_diag2?(*pos) }).to be_truthy
      }

      it('should have 12 not diag2 positions ') { expect(others.size).to be 12}
      it('should not be truthy on any other') {
        expect(others.any?{|pos| subject.is_diag2?(*pos)}).not_to be_truthy
      }
    end
  end

  describe '#get_all_ranges' do
    context 'on 3x3 grid' do
      it('should return 8 ranges (3 cols, 3 rows, 2 diags)'){expect(subject.get_all_ranges.size).to eq(8)}
    end

    context 'on 9x9 grid' do
      it('should return 20 ranges (9 cols, 9 rows, 2 diags)'){expect(described_class.new(9).get_all_ranges.size).to eq(20)}
    end

    context 'on 10x10 grid' do
      it('should return 22 ranges (10 cols, 10 rows, 2 diags)'){expect(described_class.new(10).get_all_ranges.size).to eq(22)}
    end
  end


end
