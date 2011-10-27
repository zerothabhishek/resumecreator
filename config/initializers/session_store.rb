# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_resume002_session',
  :secret      => '961dd331b137e66869c3c546d2020733cc4b2284ec88ea6496697343482d284e516e0b905ba5804e5bde7bd10dcc53d064a5d58ecce39bac71bc9b7ce1e9c007'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
