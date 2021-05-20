require 'api_constraints.rb'

Rails.application.routes.draw do
  namespace :api, default: {format: :json} do
    
    # This sets the authentication route for devise
    # localhost:3000/api/auth/...
    mount_devise_token_auth_for 'User', at: 'auth'

    # Works with the version 1 of the API, configured in ./lib/api_constraints.rb
    # localhost:3000/api/posts
    scope module: :v1,
          constraints: ApiConstraints.new(version: 1, default: true) do
      resources :posts
    end
  end
end
