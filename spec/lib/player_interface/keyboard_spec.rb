RSpec.describe PlayerInterface::Keyboard do
  def silence!(&block)
    original_stdout = $stdout
    $stdout = Tempfile.new('rspec.stdout')
    yield
    $stdout = original_stdout
  end

  let(:board){Board.new(3)}
  let(:player){Player.new('X', described_class)}
  subject{ player.interface }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:gets){ '1,1' }
    allow_any_instance_of(described_class).to receive(:print)
  end

  context "#pick" do
    def stub_gets(col,row)
      allow(subject).to receive(:gets){ '%s, %s' % [col,row]}
    end

    def test_pick_method(col,row)
      expect( subject.pick(board).inspect ).to eql('[%s, %s]' % [col,row])
    end

    it('should return [1,2] when input 2,3'){
      stub_gets(2,3)
      test_pick_method(1,2)
    }

    it('should return [1,1] when input 2,2'){
      stub_gets(2,2)
      test_pick_method(1,1)
    }

    it('should return [1,0] when input 2,1'){
      stub_gets(2,1)
      test_pick_method(1,0)
    }

    it 'should ask multiple times if col is not valid' do
      allow(subject).to receive(:gets){ @gets_options ||= ['1,1','0,1','4,1'];@gets_options.rotate!.first}
      expect(subject).to receive(:gets).exactly(3).times
      silence!{subject.pick(board)}
    end

    it 'should ask multiple times if row is not valid' do
      allow(subject).to receive(:gets){ @gets_options ||= ['1,1','1,0','1,4'];@gets_options.rotate!.first}
      expect(subject).to receive(:gets).exactly(3).times
      silence!{subject.pick(board)}
    end

    it 'should loop if position is not available' do
      board.cells[0] = player
      board.cells[3] = player

      allow(subject).to receive(:gets){ @gets_options ||= ['1,1','1,2','2,1'];@gets_options.rotate!.first}
      expect(subject).to receive(:gets).exactly(2).times
      silence!{subject.pick(board)}
    end
  end

  it_behaves_like 'a player interface'
end
