# frozen_string_literal: true

require_relative 'setup'

class FigoTest < MiniTest::Spec
  ##   Account Setup & Synchronization
  # Retrieve List of Supported Banks, Credit Cards, other Payment Services
  def test_retrieve_list_of_supported_baks_cards_services
    assert_nil figo_session.list_complete_catalog('DE', 'whatever')
  end

  # Retrieve List of Supported Credit Cards and other Payment Services
  def test_retrieve_list_of_supported_cards_services
    assert_nil figo_session.list_complete_catalog('DE', 'services')
  end

  # Retrieve List of all Supported Banks
  def test_retreive_list_of_all_supported_banks
    assert_raises(Figo::Error) { figo_session.list_complete_catalog('DE', 'banks') }
  end

  # Retrieve Login Settings for a Bank or Service
  def test_retreive_login_settings_for_a_bank_or_service
    assert_raises(Figo::Error) { figo_session.find_bank('B1.1') }
  end

  # Setup New Bank Account
  def test_setup_new_bank_account
    assert figo_session.get_bank('B1.1')
  end
end
