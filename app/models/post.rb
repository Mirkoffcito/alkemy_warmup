class Post < ApplicationRecord
  # Discard is in charge of the soft_deletion of records
  # Post.discard will soft_delete a post
  include Discard::Model

  belongs_to :category
  belongs_to :user

  validates :title, presence: true, allow_blank: false
  validates :content, presence: true

  # Validates the image regular expression
  validates :image, :format => {:with => /\.(png|jpg|gif|jpeg)\z/}

  scope :title, -> title {where("title LIKE ?", "%"+title+"%")}
  scope :category, -> category{where(category_id: category)}


  # Validates the EXISTENCE of the url provided in the image field (a status 200)
  # if it exists, it accepts it into the database, else, it deletes it
  validate :validate_url

  def validate_url
    unless self.image.blank?
      begin
        source = URI.parse(self.image)
        resp = Net::HTTP.get_response(source)
      rescue URI::InvalidURIError
        errors.add(:image,'is an Invalid url (doesnt exist)')
      rescue SocketError 
        errors.add(:image,'is Invalid')
      end
    end
  end

end
