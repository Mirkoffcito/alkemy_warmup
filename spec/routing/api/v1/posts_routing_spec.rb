require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
    describe 'routing' do
        it { should route(:get, 'api/posts').to(action: :index, format: :json) }
        it { should route(:get, 'api/posts/1').to(action: :show, id: '1', format: :json) }
        it { should route(:post, 'api/posts').to(action: :create, format: :json) }
        it { should route(:put, 'api/posts/1').to(action: :update, id: '1', format: :json) }
        it { should route(:patch, 'api/posts/1').to(action: :update, id: '1', format: :json) }
        it { should route(:delete, 'api/posts/1').to(action: :destroy, id: '1', format: :json) }
    end
end
