# frozen_string_literal: true

require_relative 'setup'

class FigoTest < MiniTest::Spec
  include Setup

  def test_get_catalog_client_auth
    response = figo_connection.list_complete_catalog
    assert response.services.instance_of? Array
    assert response.banks.instance_of? Array
    assert response.banks.first.instance_of? Figo::Bank if response.banks.count > 0
    assert response.services.first.instance_of? Figo::Service if response.services.count > 0
  end

  def test_get_catalog_user_auth
    create_user
    response = figo_session.list_complete_catalog
    assert response.services.instance_of? Array
    assert response.banks.instance_of? Array
    assert response.banks.first.instance_of? Figo::Bank if response.banks.count > 0
    assert response.services.first.instance_of? Figo::Service if response.services.count > 0
    destroy_user
  end

  def test_get_services_catalog_user_auth
    create_user
    response = figo_session.list_complete_catalog(objects: 'services')
    assert response.instance_of? Array
    destroy_user
  end

  def test_get_banks_catalog_user_auth
    create_user
    response = figo_session.list_complete_catalog(objects: 'banks')
    assert response.instance_of? Array
    destroy_user
  end
end
