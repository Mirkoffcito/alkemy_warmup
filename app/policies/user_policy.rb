class CategoryPolicy < ApplicationPolicy

    def index?
        user.role == "admin"
    end

end