ruby-figo [![Build Status](https://secure.travis-ci.org/figo-connect/ruby-figo.png)](https://travis-ci.org/figo-connect/ruby-figo)
=========

Ruby bindings for the figo connect API: http://figo.me

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
    session = Figo::Session.create("ASHWLIkouP2O6_bgA2wWReRhletgWKHYjLqDaqb0LFfamim9RjexTo22ujRIP_cjLiRiSyQXyt2kM1eXU2XLFZQ0Hro15HikJQT_eNeT_9XQ")
	
	# print out a list of accounts including its balance
	session.accounts.each do |account|
		puts account
		puts account.balance
	end

	# print out the list of all transactions on a specific account
	session.get_account("A1.2").transactions do |transaction|
	    puts transaction
	end
```

Requirements
============

This gem requires Ruby 1.9.
