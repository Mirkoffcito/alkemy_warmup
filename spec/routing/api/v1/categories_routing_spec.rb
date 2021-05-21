require "rails_helper"

RSpec.describe Api::V1::CategoriesController, type: :routing do
  describe "routing" do
    it { should route(:get, 'api/categories').to(action: :index, format: :json) }
    it { should route(:get, 'api/categories/1').to(action: :show, id: '1', format: :json) }
    it { should route(:post, 'api/categories').to(action: :create, format: :json) }
    it { should route(:put, 'api/categories/1').to(action: :update, id: '1', format: :json) }
    it { should route(:patch, 'api/categories/1').to(action: :update, id: '1', format: :json) }
    it { should route(:delete, 'api/categories/1').to(action: :destroy, id: '1', format: :json) }
  end
end
