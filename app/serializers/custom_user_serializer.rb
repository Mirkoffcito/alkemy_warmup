class CustomUserSerializer < ActiveModel::Serializer
    attributes :id, :email, :uid, :created_at, :updated_at
  end
  