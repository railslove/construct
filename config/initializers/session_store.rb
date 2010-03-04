# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_construct_session',
  :secret      => 'd39c04979c626668ff154febfee7a04e6ce0a811ea43eae78f9aaed6eff70e12ea83a54c22c398468e95d97613bed8149ad8252bba74d569e8c744fa1b3ff119'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
