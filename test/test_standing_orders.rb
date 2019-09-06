# frozen_string_literal: true

require_relative 'setup'

class FigoTest < MiniTest::Spec
  include Setup

  before { create_user }
  after { destroy_user }

  ##  Standing orders
  # Retrieve all Standing orders
  def test_retrieve_all_standing_orders
    standing_orders = figo_session.get_standing_orders

    assert standing_orders.instance_of?(Array)
  end
end
