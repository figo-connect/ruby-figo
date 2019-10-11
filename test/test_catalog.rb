# frozen_string_literal: true

require_relative 'setup'

class FigoTest < MiniTest::Spec
  include Setup

  def test_get_catalog_client_auth
    response = figo_connection.list_complete_catalog
    if response
      assert response.services.instance_of? Array
      assert response.banks.instance_of? Array
      assert response.banks.first.instance_of? Figo::Model::Bank if response.banks.count.positive?
      assert response.services.first.instance_of? Figo::Model::Service if response.services.count.positive?
    end
  end

  def test_get_catalog_user_auth
    create_user
    response = figo_session.list_complete_catalog
    if response
      assert response.services.instance_of? Array
      assert response.banks.instance_of? Array
      assert response.banks.first.instance_of? Figo::Model::Bank if response.banks.count.positive?
      assert response.services.first.instance_of? Figo::Model::Service if response.services.count.positive?
    end
    destroy_user
  end

  def test_get_services_catalog_user_auth
    create_user
    response = figo_session.list_services
    if response
      assert response.instance_of? Array
      assert response.first.instance_of? Figo::Model::Service if response.count.positive?
    end
    destroy_user
  end

  def test_get_services_catalog_client_auth
    response = figo_connection.list_services
    if response
      assert response.instance_of? Array
      assert response.first.instance_of? Figo::Model::Service if response.count.positive?
    end
  end

  def test_get_banks_catalog_user_auth
    create_user
    response = figo_session.list_banks
    if response
      assert response.instance_of? Array
      assert response.first.instance_of? Figo::Model::Bank if response.count.positive?
    end
    destroy_user
  end

  def test_get_banks_catalog_client_auth
    response = figo_connection.list_banks
    if response
      assert response.instance_of? Array
      assert response.first.instance_of? Figo::Model::Bank if response.count.positive?
    end
  end
end