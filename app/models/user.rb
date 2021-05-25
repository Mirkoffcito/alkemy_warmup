# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :posts, dependent: :destroy

  # sets de default values for the user's role
  enum role: [:normal, :admin]
  after_initialize :set_defaults

  # This method overrides the json response when we sign_in
  # with our own serializer in serializers
  def token_validation_response
    CustomUserSerializer.new(self, root: false)
  end

  private

  def set_defaults
    if self.new_record?
      self.role ||= :normal # We use ||= so if we create a User with a role, it does not overwrite it
    end
  end

end
