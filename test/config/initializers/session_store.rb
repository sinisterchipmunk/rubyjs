# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_2.0_session',
  :secret      => 'b536841de77bb05f0216bb502fca289ca3e3eb9c87658fb0fe6592cf34527055e10ecccbf2c8bb5aec4ac664734505f1769ab774f75680150f84ab5bcfac3898'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
