# frozen_string_literal: true

require_relative 'setup'

class FigoTest < MiniTest::Spec
  include Setup

  def test_list_synchronization_challenges
    catalog = figo_connection.list_complete_catalog
  end
end
