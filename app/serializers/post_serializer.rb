class PostSerializer < ActiveModel::Serializer

  attributes :id, :title, :content, :image, :category, :created_at

  belongs_to :user
  # Calls the Category serializer
  def category
    ActiveModel::SerializableResource.new(object.category, each_serializer: CategoriesSerializer)
  end

end
