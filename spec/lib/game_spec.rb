require 'tempfile'
require 'player_interface/random'

RSpec.describe Game do

  def silence!(&block)
    original_stdout = $stdout
    $stdout = Tempfile.new('rspec.stdout')
    yield
    $stdout = original_stdout
  end

  subject{ Game.new(3, [player1, player2, player3]) }
  let(:player1){ Player.new('X', PlayerInterface::Random) }
  let(:player2){ Player.new('O', PlayerInterface::Random) }
  let(:player3){ Player.new('A', PlayerInterface::Random) }

  describe '#initialize(size, players)' do
    it('should create new board with informed size'){
      expect(Board).to receive(:new).with(3).once.and_call_original
      Game.new(3, [])
    }
  end

  describe "#start!" do
    it("should print the rules") do
      expect(subject).to receive(:print_rules){nil}
      silence!{ subject.start! }
    end

    it("should print the result on game over") do
      expect(subject.board).to receive(:game_over?){true}
      expect(subject).to receive(:print_result){nil}
      silence!{ subject.start! }
    end

    it('should not call player.pick if game over') do
      expect(subject.board).to receive(:game_over?){true}
      expect(player1).not_to receive(:pick)
      expect(player2).not_to receive(:pick)
      expect(player3).not_to receive(:pick)
      silence!{ subject.start! }
    end

    it('should call player1 first') do
      allow(subject.board).to receive(:game_over?){ subject.board.cells.any?{|c| c == player1 } }
      expect(player1).to receive(:pick){[0,0]}
      expect(player2).not_to receive(:pick)
      expect(player3).not_to receive(:pick)
      silence!{ subject.start! }
    end

    it('should play in order') do
      allow(subject.board).to receive(:game_over?){ subject.board.cells.count{|e| !e.nil? } > 4 }
      expect(subject.board).to receive(:set).with(anything, anything, player1).once.and_call_original.ordered
      expect(subject.board).to receive(:set).with(anything, anything, player2).once.and_call_original.ordered
      expect(subject.board).to receive(:set).with(anything, anything, player3).once.and_call_original.ordered
      expect(subject.board).to receive(:set).with(anything, anything, player1).once.and_call_original.ordered
      expect(subject.board).to receive(:set).with(anything, anything, player2).once.and_call_original.ordered
      silence!{ subject.start! }
    end
  end

end
