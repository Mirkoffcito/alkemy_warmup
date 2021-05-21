require 'rails_helper'

# You can read more about devise_token_auth endopoints in https://devise-token-auth.gitbook.io/devise-token-auth/usage

RSpec.describe DeviseTokenAuth::PasswordsController, type: :controller do

  # sends password reset-confirmation email
  # takes email as parameter and if it maches a user's email
  # an email will be sent  to the user to reset their password
  it { should route(:post, 'api/auth/password').to(action: :create, format: :json) }

  # Used to change user's pasword.
  # Takes password and password_confirmation as params, and also
  # checks current_password param if config.check_current_password_before_update is set to true
  it { should route(:put, 'api/auth/password').to(action: :update, format: :json) }
end