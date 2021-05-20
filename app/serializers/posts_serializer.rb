class PostsSerializer < ActiveModel::Serializer

    attributes :id, :title, :image, :category, :created_at
  
    # Calls the Category serializer
    def category
      ActiveModel::SerializableResource.new(object.category, each_serializer: CategoriesSerializer)
    end
  
    def user
      ActiveModel::SerializableResource.new(object.user, each_serializer: UserSerializer)
    end
  
  end