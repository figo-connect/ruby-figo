require "flt"
require "minitest/autorun"
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
require_relative "../lib/figo"

require_relative 'setup'

class FigoTest < MiniTest::Unit::TestCase
  include Setup

  ##  Standing orders
  # Retrieve all Standing orders
  def test_retrieve_all_standing_orders
    standing_orders = figo_session.get_standing_orders()

    assert standing_orders.instance_of?(Array)
  end
end
