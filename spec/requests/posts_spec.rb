require 'rails_helper'

# rubocop: disable Metrics/BlockLength
RSpec.describe '/api/posts', type: :request do
  let(:user) { create :user }
  let(:category) { create :category }
  let(:post) { create :post, user: user, category: category }
  let(:post_two) { create :post, user: create(:user), category: create(:category) }

  let(:valid_attributes) { attributes_for :post, user: user }
  let(:invalid_attributes) { attributes_for :invalid_post, user: user }

  let(:valid_headers) do
    user.create_new_auth_token.merge('Accept' => 'application/vnd.blog.v1')
  end
  
  let(:invalid_headers) do
    { 'Accept' => 'application/vnd.blog.v1' }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get api_posts_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end

    it 'renders only posts from logged user' do
      post
      post_two

      get api_posts_url, headers: valid_headers, as: :json
      expect(json_response.size).to eq 1
      expect(json_response[0][:id]).to eq post.id
    end

    it_behaves_like 'user not logged in' do
      let(:url) { get api_posts_url, headers: invalid_headers, as: :json }
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get api_post_url(post), headers: valid_headers, as: :json
      expect(response).to be_successful
    end

    it_behaves_like "trying to access another user's resource" do
      let(:url) do
        get api_post_url(post_two), headers: valid_headers, as: :json
      end
    end

    it_behaves_like 'user not logged in' do
      let(:url) do
        get api_post_url(post), headers: invalid_headers, as: :json
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new post' do
        expect do
          post api_posts_url,
               params: { post: valid_attributes },
               headers: valid_headers,
               as: :json
        end.to change(post, :count).by(1)
      end

      it 'renders a JSON response with the new post' do
        post api_posts_url,
             params: { post: valid_attributes },
             headers: valid_headers,
             as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new post' do
        expect do
          post api_posts_url,
               params: { post: invalid_attributes },
               headers: valid_headers,
               as: :json
        end.to change(post, :count).by(0)
      end

      it 'renders a JSON response with errors for the new post' do
        post api_posts_url,
             params: { post: invalid_attributes },
             headers: valid_headers,
             as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    it_behaves_like 'user not logged in' do
      let(:url) do
        post api_posts_url,
             params: { post: valid_attributes },
             headers: invalid_headers,
             as: :json
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) { attributes_for :post }

      it 'updates the requested post' do
        patch api_post_url(post),
              params: { post: new_attributes },
              headers: valid_headers,
              as: :json
        post.reload
        expect(post.title).to eq(new_attributes[:title])
      end

      it 'renders a JSON response with the post' do
        patch api_post_url(post),
              params: { post: new_attributes },
              headers: valid_headers,
              as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the post' do
        patch api_post_url(post),
              params: { post: invalid_attributes },
              headers: valid_headers,
              as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    it_behaves_like "trying to access another user's resource" do
      let(:url) do
        patch api_post_url(post_two), headers: valid_headers, as: :json
      end
    end

    it_behaves_like 'user not logged in' do
      let(:url) do
        patch api_post_url(post),
              params: { post: valid_attributes },
              headers: invalid_headers,
              as: :json
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested post' do
      post
      expect do
        delete api_post_url(post), headers: valid_headers, as: :json
      end.to change(post, :count).by(-1)
    end

    it_behaves_like "trying to access another user's resource" do
      let(:url) do
        delete api_post_url(post_two), headers: valid_headers, as: :json
      end
    end

    it_behaves_like 'user not logged in' do
      let(:url) do
        delete api_post_url(post), headers: invalid_headers, as: :json
      end
    end
  end
end