# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rewrite_session',
  :secret      => '66e2465d33eda568f8f2e011ca93b065c15f81abf465c830114d635a3cfbcecf3abc8cf916660fea8797186b2885fa9e746af7ddc7fbff16cb182f5174530130'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
