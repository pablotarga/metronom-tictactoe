RSpec.describe Player do

  subject{ Player.new('X', PlayerInterface::Random) }

  describe '#initialize(symbol, interface=PlayerInterface::Keyboard)' do
    it('should store informed symbol') do
      expect(subject.symbol).to be_eql('X')
    end

    it('should store informed interface') do
      expect(subject.interface).to be_a(PlayerInterface::Random)
    end
  end

  it { should delegate_method(:pick).to(:interface) }
end
