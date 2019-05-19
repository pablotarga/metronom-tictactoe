shared_examples_for 'a player interface' do
  let(:board){ Board.new(3) }
  let(:player){ Player.new('X', described_class) }
  subject { player.interface }

  it('should create new interface') { should be_truthy }

  it('should require to be initialized with a player'){
    expect{described_class.new('X')}.to raise_error(ArgumentError)
    expect{described_class.new(player)}.not_to raise_error
  }

  it{ should respond_to :pick }
  describe "#pick" do
    it('should have one argument'){ expect(subject.method(:pick).arity).to eq(1) }
    it('should allow Board as argument'){ expect{subject.pick(board)}.not_to raise_error }
    it('should raise error on invalid argument'){ expect{subject.pick('X')}.to raise_error(ArgumentError) }
  end
end
