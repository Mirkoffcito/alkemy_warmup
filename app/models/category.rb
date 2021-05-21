class Category < ApplicationRecord
    has_many :posts

    validates :name, presence: true, allow_blank: false
end
