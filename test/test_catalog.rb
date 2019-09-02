# frozen_string_literal: true

require_relative 'setup'

class FigoTest < MiniTest::Spec
  include Setup

  def test_get_catalog_client_auth
    response = figo_connection.get_supported_payment_services
    assert response.services.instance_of? Array
    assert response.banks.instance_of? Array
  end

  def test_get_catalog_user_auth
    create_user
    response = figo_session.get_supported_payment_services
    assert response.services.instance_of? Array
    assert response.banks.instance_of? Array
    destroy_user
  end

  # Works but `GET /catalog` is very slow
  # def test_get_services_catalog_user_auth
  #   response = figo_session.get_supported_payment_services(objects: "services")
  #   assert response.instance_of? Array
  # end
end
