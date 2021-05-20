# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :posts, dependent: :destroy

  # This method overrides the json response when we sign_in
  # with our own serializer in serializers
  def token_validation_response
    CustomUserSerializer.new(self, root: false)
  end
end
