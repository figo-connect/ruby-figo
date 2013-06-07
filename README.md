ruby-figo [![Build Status](https://secure.travis-ci.org/figo-connect/ruby-figo.png)](https://travis-ci.org/figo-connect/ruby-figo)
=========

Ruby bindings for the figo Connect API: http://developer.figo.me

Usage
=====

First, you've to install the gem

```bash
    gem install figo
```

and require it

```ruby
    require "figo"
```

Now you can create a new session and access data:

```ruby
    session = Figo::Session.new("ASHWLIkouP2O6_bgA2wWReRhletgWKHYjLqDaqb0LFfamim9RjexTo22ujRIP_cjLiRiSyQXyt2kM1eXU2XLFZQ0Hro15HikJQT_eNeT_9XQ")
    
    # Print out a list of accounts.
    session.accounts.each do |account|
      puts account
      puts account.balance
    end

    # Print out the list of all transactions of a specific account.
    session.get_account("A1.2").transactions.each do |transaction|
      puts transaction
    end
```

You can find more documentation at http://rubydoc.info/github/figo-connect/ruby-figo/master/frames

Requirements
============

This gem requires Ruby 1.9.
