require 'rails_helper'

RSpec.describe Post, type: :model do
  subject(:post) { build :post }

  describe 'associations' do
    it { should belong_to(:user) }

    it { should belong_to(:category) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should allow_value('https://dropbox.com/image.jpg').for(:image)}
  end
  
end
