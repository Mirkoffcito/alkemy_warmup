require 'rails_helper'

# You can read more about devise_token_auth endopoints in https://devise-token-auth.gitbook.io/devise-token-auth/usage

RSpec.describe DeviseTokenAuth::SessionsController, type: :controller do
  it { should route(:post, 'api/auth/sign_in').to(action: :create, format: :json) }
  it { should route(:delete, 'api/auth/sign_out').to(action: :destroy, format: :json) }
end