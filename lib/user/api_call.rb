# frozen_string_literal: true
require_relative '../model/user'

module Figo
  # Retrieve current User
  # @return [User] the current user
  def get_user
    query_api_object Model::User, '/rest/user'
  end

  # Modify the current user
  #
  # @param user [User] the modified user object to be saved
  # @return [User] the modified user returned
  def modify_user(user)
    query_api_object Model::User, '/rest/user', user.to_hash, 'PUT'
  end

  # Remove the current user
  # @note: this has immidiate effect and you wont be able to interact with the user after this call
  def remove_user
    query_api '/rest/user', nil, 'DELETE'
  end

  # # Re-send verification email
  # #
  # def resend_verification
  #   query_api '/rest/user/resend_verification', nil, 'POST'
  # end

  # Create a new figo Account
  # @param name [String] First and last name
  # @param email [String] Email address; It must obey the figo username & password policy
  # @param password [String] New figo Account password; It must obey the figo username & password policy
  # @param language [String] Two-letter code of preferred language
  # @return [Hash]  an object with the key `recovery_password` as documented in the figo Connect API specification.
  def create_user(email, password, full_name = nil, language = nil)
    options = { email: email, password: password }
    options[:language] = language if language
    options[:full_name] = full_name if full_name

    query_api '/auth/user', options
  end
end
