ruby-figo [![Build Status](https://secure.travis-ci.org/figo-connect/ruby-figo.png)](https://travis-ci.org/figo-connect/ruby-figo) [![Gem Version](http://img.shields.io/gem/v/figo.svg)](http://rubygems.org/gems/figo)
=========

Ruby bindings for the figo Connect API: http://docs.figo.io

Usage
=====

First, you've to install the gem:

```bash
gem install figo
```

Now you can create a new session and access data:

```ruby
require "figo"

session = Figo::Session.new(<acces_token>)

# Print out list of account numbers and balances.
session.accounts.each do |account|
  puts account.account_number
  puts account.balance.balance
end

# Print out the list of all transaction originators/recipients of a specific account.
session.get_account("A1.1").transactions.each do |transaction|
  puts transaction.name
end
```

```ruby
require 'figo'
require 'launchy'

connection = Figo::Connection.new(<client_id>, <client_secret>)

# Trade in user credentials, refresh token or authorization code for access token.
token_hash = connection.user_credential_request(<username>, <password>) # or..
token_hash = connection.refresh_token_request(<refresh_token>) # or..
token_hash = connection.authorization_code_request(<authorization_code>, <redirect_uri>)

# Start session.
session = Figo::Session.new(token_hash['access_token'])

# Retrieve data
session.accounts.each do |account|
  puts account.account_number
  ...
}
```

You can find more documentation at http://rubydoc.info/github/figo-connect/ruby-figo/master/frames

Requirements
------------

This gem requires Ruby 1.9.
