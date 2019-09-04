# frozen_string_literal: true

require_relative 'setup'

class FigoTest < MiniTest::Spec
  include Setup

  def test_get_catalog_client_auth
    response = figo_connection.list_complete_catalog
    assert response.services.instance_of? Array
    assert response.banks.instance_of? Array
    assert response.banks.first.instance_of? Figo::Bank
    assert response.services.first.instance_of? Figo::Service
  end

  def test_get_catalog_user_auth
    create_user
    response = figo_session.list_complete_catalog
    assert response.services.instance_of? Array
    assert response.banks.instance_of? Array
    assert response.banks.first.instance_of? Figo::Bank
    assert response.services.first.instance_of? Figo::Service
    destroy_user
  end

  # Works but `GET /catalog` is very slow
  # def test_get_services_catalog_user_auth
  #   response = figo_session.list_complete_catalog(objects: "services")
  #   assert response.instance_of? Array
  # end
end
