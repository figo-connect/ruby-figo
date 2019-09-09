# frozen_string_literal: true

require_relative 'setup'

class FigoTest < MiniTest::Spec
  include Setup

  # Retrieve Transactions of all Accounts
  def test_accesses
    create_user
    access_method_id = figo_session.list_banks.first.access_methods.first.id
    figo_session.add_access(access_method_id) # add provider access
    access = figo_session.accesses.first # list provider accesses
    assert figo_session.get_access(access.id).instance_of? Figo::Model::Access # get provider access
    assert figo_session.get_access(access.id).instance_of? Figo::Model::Access # remove stored pin
    destroy_user
  end
end