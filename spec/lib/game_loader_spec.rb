require 'json'
require 'yaml'

RSpec.describe GameLoader do
  let(:config){ {'size' => 3, 'players' => {'X' => :ai, 'O' => :keyboard}} }
  let(:config_yaml){YAML.dump(config)}
  let(:config_json){config.to_json}

  describe '#initialize(input, parser=YAML)' do
    def stub_filepath(path, content)
      file = double()
      allow(file).to receive(:read){content}
      allow(File).to receive(:exists?).with(path){true}
      allow(File).to receive(:open).with(path, 'r'){file}
    end

    def expect_config(input, parser)
      size, players = GameLoader.new(input, parser).extract_config
      expect(size).to be 3
      expect(players.size).to be 2
    end

    it('accepts input as string'){expect_config(config_yaml, YAML)}

    it('accepts input as readable') do
      readable = double()
      allow(readable).to receive(:read){ config_yaml }
      expect_config(readable, YAML)
    end

    it('accepts input as filepath') do
      path = 'tmp/config.yml'
      stub_filepath(path, config_yaml)
      expect_config(path, YAML)
    end

    it('accepts JSON parser') do
      expect_config(config_json, JSON)
    end

    it('accepts loadable parser') do
      loadable = double()
      allow(loadable).to receive(:load).with('XXX'){ config }

      expect_config('XXX', loadable)
    end
  end
end
