require_relative "lib/figo"

session = Figo::Session.new("ASHWLIkouP2O6_bgA2wWReRhletgWKHYjLqDaqb0LFfamim9RjexTo22ujRIP_cjLiRiSyQXyt2kM1eXU2XLFZQ0Hro15HikJQT_eNeT_9XQ")

# Print out list of account numbers and balances.
session.accounts.each do |account|
  puts account.account_number
  puts account.balance.balance
end

# Print out the list of all transaction originators/recipients of a specific account.
session.get_account("A1.1").transactions.each do |transaction|
  puts transaction.name
end
