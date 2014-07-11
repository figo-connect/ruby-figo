require 'rubygems'
require 'sinatra'
require_relative '../lib/figo'

CLIENT_ID = "CaESKmC8MAhNpDe5rvmWnSkRE_7pkkVIIgMwclgzGcQY"
CLIENT_SECRET = "STdzfv0GXtEj_bwYn7AgCVszN1kKq5BdgEIKOM_fzybQ"
connection = Figo::Connection.new(CLIENT_ID, CLIENT_SECRET, "http://localhost:3000/callback")

configure do
  enable :sessions
  set :port, 3000
end

get '/callback*' do
  if params['state'] != "qweqwe"
    logger.info "qwe"
    raise Exception.new("Bogus redirect, wrong state")
  end

  token_hash = connection.obtain_access_token(params['code'])
  request.session['figo_token'] = token_hash['access_token']

  redirect to('/')
end

get '/logout' do
  request.session['figo_token'] = nil
  redirect to('/')
end

before '/' do
  logger.info request.path_info
  unless session[:figo_token] or request.path_info == "/callback" then
    redirect to(connection.login_url("qweqwe", "accounts=ro transactions=ro balance=ro user=ro"))
  end
end

get '/:account_id' do | account_id |
  session = Figo::Session.new(request.session['figo_token'])
  @accounts = session.accounts
  @current_account = session.get_account(account_id)
  @transactions = @current_account.transactions
  @user = session.user

  erb :index
end

get '/' do
  session = Figo::Session.new(request.session['figo_token'])
  @accounts = session.accounts
  @current_account = nil
  @transactions = session.transactions
  @user = session.user

  erb :index
end
