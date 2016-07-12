require_relative "model.rb"
module Figo
  # Retrieve current User
  #
  # @return [User] the current user
  def user
    query_api_object User, "/rest/user"
  end

  # Modify the current user
  #
  # @param user [User] the modified user object to be saved
  # @return [User] the modified user returned
  def modify_user(user)
    query_api_object User, "/rest/user", user.dump(), "PUT"
  end

  # Remove the current user
  # Note: this has immidiate effect and you wont be able to interact with the user after this call
  #
  def remove_user
    query_api "/rest/user", nil, "DELETE"
  end

  # Re-send verification email
  #
  def resend_verification
    query_api "/rest/user/resend_verification", nil, "POST"
  end

  # Create a new figo Account
  # @param name [String] First and last name
  # @param email [String] Email address; It must obey the figo username & password policy
  # @param password [String] New figo Account password; It must obey the figo username & password policy
  # @param language [String] Two-letter code of preferred language
  # @param send_newsletter [Boolean] This flag indicates whether the user has agreed to be contacted by email
  # @return [Hash]  an object with the key `recovery_password` as documented in the figo Connect API specification.
  def create_user(name, email, password, language, send_newsletter=nil)
    options = { name: name, email: email, password: password, send_newsletter: send_newsletter }
    options["language"] = language if (language)
    options["send_newsletter"] = !!send_newsletter == send_newsletter ? send_newsletter : nil

    query_api "/auth/user", options
  end

end
