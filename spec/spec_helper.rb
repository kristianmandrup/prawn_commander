require 'rspec'
require 'rspec/autorun'   
require 'prawn'
require 'prawn_commander'
require 'matcher/command_matcher'

RSpec.configure do |config|
  config.mock_with :mocha
  config.include(Matchers)    
end
