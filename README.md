ruby-figo [![Build Status](https://secure.travis-ci.org/figo-connect/ruby-figo.png)](https://travis-ci.org/figo-connect/ruby-figo) [![Gem Version](http://img.shields.io/gem/v/figo.svg)](http://rubygems.org/gems/figo)
=========

Ruby bindings for the figo Connect API: http://docs.figo.io

Usage
=====

First, you've to install the gem:

```bash
gem install figo
```

Now you can retrieve data with an user bound session

```ruby
require 'figo'
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