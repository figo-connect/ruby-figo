# frozen_string_literal: true
require_relative '../model/synchronization_challenge'

module Figo
  # List synchronization challenges
  #
  # @param access_id [String] figo ID of the provider access.
  # @param sync_id [String] figo ID of synchronization operation.
  # @return [Array] an array of `SynchronizationChallenge` objects
  def list_synchronization_challenges(access_id, sync_id)
    path = "/rest/accesses/#{access_id}/syncs/#{sync_id}/challenges"
    query_api_object Model::SynchronizationChallenge, path, nil, 'GET', 'synchronization_challenges'
  end

  # Get synchronization challenge
  #
  # @param access_id [String] figo ID of the provider access.
  # @param sync_id [String] ID of the access to be retrieved.
  # @param challenge_id [String] ID of the access to be retrieved.
  # @return [Object] a SynchronizationChallenge object
  def get_synchronization_challenge(access_id, sync_id, challenge_id)
    path = "/rest/accesses/#{access_id}/syncs/#{sync_id}/challenges/#{challenge_id}"
    query_api_object Model::SynchronizationChallenge, path, nil, 'GET'
  end

  # Solve synchronization challenge
  #
  # @param access_id [String] figo ID of the provider access.
  # @param sync_id [String] ID of the access to be retrieved.
  # @param challenge_id [String] ID of the access to be retrieved.
  # @return [Object]
  def solve_synchronization_challenge(access_id, sync_id, challenge_id, data)
    path = "/rest/accesses/#{access_id}/syncs/#{sync_id}/challenges/#{challenge_id}/response"
    query_api path, data, 'POST'
  end

  # List payment challenges
  #
  # @param account_id [String] figo ID of account.
  # @param payment_id [String] figo ID of the payment.
  # @param init_d [String] figo ID of the payment initation.
  # @return [Array] an array of `SynchronizationChallenge` objects
  def list_payment_challenges(account_id, payment_id, init_d)
    path = "/rest/accounts/#{account_id}/payments/#{payment_id}/init/#{init_id}/challenges"
    query_api_object Model::SynchronizationChallenge, path, nil, 'GET', 'synchronization_challenges'
  end

  # Get payment challenge
  #
  # @param account_id [String] figo ID of account.
  # @param payment_id [String] figo ID of the payment.
  # @param init_d [String] figo ID of the payment initation.
  # @param challenge_id [String] figo ID of the challenge.
  # @return [Object] a SynchronizationChallenge object
  def get_payment_challenge(account_id, payment_id, init_d, challenge_id)
    path = "/rest/accounts/#{account_id}/payments/#{payment_id}/init/#{init_id}/challenges"
    query_api_object Model::SynchronizationChallenge, path, nil, 'GET'
  end

  # Solve payment challenge
  #
  # @param account_id [String] figo ID of account.
  # @param payment_id [String] figo ID of the payment.
  # @param init_d [String] figo ID of the payment initation.
  # @param challenge_id [String] figo ID of the challenge.
  # @return [Object]
  def solve_payment_challenge(account_id, payment_id, init_id, challenge_id, data)
    path = "/rest/accounts/#{account_id}/payments/#{payment_id}/init/#{init_id}/challenges/#{challenge_id}/response"
    query_api path, data, 'POST'
  end
end