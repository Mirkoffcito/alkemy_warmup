class Post < ApplicationRecord
  belongs_to :category
  belongs_to :user

  validates :title, presence: true, allow_blank: false
  validates :content, presence: true

  # Validates the image regular expression
  validates :image, :format => {:with => /\.(png|jpg|gif|jpeg)\z/}

  scope :title, -> title {where("title LIKE ?", "%"+title+"%")}
  scope :category, -> category{where(category_id: category)}
end
