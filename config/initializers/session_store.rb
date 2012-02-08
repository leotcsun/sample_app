# Be sure to restart your server when you modify this file.

SampleApp::Application.config.session_store :cookie_store, :key => '_sample_app_session'

# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# SampleApp::Application.config.session_store :active_record_store
