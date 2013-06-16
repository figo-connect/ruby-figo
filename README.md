ruby-figo [![Build Status](https://secure.travis-ci.org/figo-connect/ruby-figo.png)](https://travis-ci.org/figo-connect/ruby-figo)
=========

Ruby bindings for the figo Connect API: http://developer.figo.me

Usage
=====

First, you've to install the gem

```bash
    gem install figo
```

Now you can create a new session and access data:

```ruby
    require "figo"

    session = Figo::Session.new("ASHWLIkouP2O6_bgA2wWReRhletgWKHYjLqDaqb0LFfamim9RjexTo22ujRIP_cjLiRiSyQXyt2kM1eXU2XLFZQ0Hro15HikJQT_eNeT_9XQ")
    
    # Print out a list of account numbers and balances.
    session.accounts.each do |account|
      puts account.account_number
      puts account.balance.balance
    end

    # Print out the list of all transaction originators/recipients of a specific account.
    session.get_account("A1.1").transactions.each do |transaction|
      puts transaction.name
    end
```

It is just as simple to allow users to login through the API:

```ruby
    require "figo"
    require "launchy"

    connection = Figo::Connection.new("<client ID>", "<client secret>", "http://my-domain.org/redirect-url")

    def start_login
      # Open webbrowser to kick of the login process.
      Launchy.open(connection.login_url("qweqwe"))
    end

    def process_redirect(authorization_code, state)
      # Handle the redirect URL invocation from the initial start_login call.

      # Ignore bogus redirects.
      if state != "qweqwe"
        return
      end

      # Trade in authorization code for access token.
      token_hash = connection.obtain_access_token(authorization_code)

      # Start session.
      session = Figo::Session.new(token_hash["access_token"])
  
      # Print out a list of account numbers.
      session.accounts.each do |account|
        puts account.account_number
      end
    end
```

You can find more documentation at http://rubydoc.info/github/figo-connect/ruby-figo/master/frames

Requirements
============

This gem requires Ruby 1.9.
