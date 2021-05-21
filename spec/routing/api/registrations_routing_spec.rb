require 'rails_helper'

# You can read more about devise_token_auth endopoints in https://devise-token-auth.gitbook.io/devise-token-auth/usage

RSpec.describe DeviseTokenAuth::RegistrationsController, type: :controller do
  it { should route(:post, 'api/auth').to(action: :create, format: :json) }  # Email registration
  it { should route(:put, 'api/auth').to(action: :update, format: :json) } # Account updates. (password, name, etc)
  it { should route(:delete, 'api/auth').to(action: :destroy, format: :json) }  # Account deletion
end