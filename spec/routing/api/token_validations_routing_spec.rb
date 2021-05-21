require 'rails_helper'

# You can read more about devise_token_auth endopoints in https://devise-token-auth.gitbook.io/devise-token-auth/usage

RSpec.describe DeviseTokenAuth::TokenValidationsController, type: :controller do
  it { should route(:get, 'api/auth/validate_token').to(action: :validate_token) }
end