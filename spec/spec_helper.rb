require 'shoulda-matchers'

require 'shared/player_interface'

require 'aux/grid'
require 'aux/move_predictor'
require 'aux/board_printer'

require 'player_interface/base'
require 'player_interface/ai'
require 'player_interface/random'
require 'player_interface/keyboard'

require 'board'
require 'player'
require 'game_loader'
require 'game'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    # Keep as many of these lines as are necessary:
    # with.library :active_record
    # with.library :active_model
  end
end

RSpec.configure do |config|
  config.raise_errors_for_deprecations!

  config.fail_fast = true

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
