# frozen_string_literal: true

require_relative 'setup'

class FigoTest < MiniTest::Spec
  include Setup
 
  before { create_user }
  after { destroy_user }

  # Retrieve all Bank Accounts
  def test_retreive_all_bank_accounts
    accounts = figo_session.list_accounts
    assert accounts.instance_of? Array
    assert accounts.first.instance_of? Figo::Model::Account unless accounts.empty?
  end

  # Retrieve Bank Account
  def test_retrieve_bank_account
    accounts = figo_session.list_accounts
    unless accounts.empty?
      account = figo_session.get_account accounts.first.id
      assert account.instance_of? Figo::Model::Account
    end
  end


  # Delete bank account
  def test_delete_bank_account
    accounts = figo_session.list_accounts
    unless accounts.empty?
      account = figo_session.get_account accounts.first
      assert account.instance_of? Figo::Model::Account
      assert_nil figo_session.delete_account account.id
    end
  end

  # Retrieve Bank Account Balance and Limits
  def test_retreive_bank_account_balance_and_limits
    accounts = figo_session.list_accounts
    unless accounts.empty?
      account = figo_session.get_account accounts.first
      assert account.instance_of? Figo::Model::Account
      assert_nil figo_session.get_account_balance account.id
    end
  end

  # # Modify Bank Account
  # def test_modify_bank_account
  #   account = figo_session.get_account 'A1.2'
  #   account.name = 'new name'

  #   execption = assert_raises(Figo::Error) { figo_session.modify_account account }
  #   assert 'Missing, invalid or expired access token.', execption.message
  #   # figo_session.modify_account account

  #   # modified_account = figo_session.get_account "A1.2"
  #   # assert_equal modified_account.name "new name"
  # end

  # # Set Bank Account Sort Order
  # def test_set_account_sort_order
  #   accounts = figo_session.list_accounts
  #   execption = assert_raises(Figo::Error) { figo_session.account_sort_order(accounts) }
  #   assert 'Missing, invalid or expired access token.', execption.message

  #   # assert figo_session.account_sort_order(accounts)
  # end

  # # Modify Bank Account Credit Line and Limits
  # def test_modify_bank_account_credit_line_and_limits
  #   old_balance = figo_session.get_account_balance('A1.2')
  #   balance = old_balance.clone

  #   balance.balance = 1

  #   execption = assert_raises(Figo::Error) { figo_session.modify_account_balance('A1.2', balance) }
  #   assert 'Missing, invalid or expired access token.', execption.message
  #   # new_balance = figo_session.modify_account_balance("A1.2", balance)

  #   # assert old_balance.balance != new_balance.balance
  # end

  # # Remove Stored Pin from Bank Account
  # def test_remove_pin_from_bank_account
  #   new_bank_info = Figo::Bank.new(figo_session, bank_id: 'B1.1', sepa_creditor_id: 'DE02ZZZ0123456789', save_pin: true)
  #   response = figo_session.remove_bank_pin(new_bank_info)
  #   assert response['save_pin'] == false
  # end
end
