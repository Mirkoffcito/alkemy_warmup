class CategoryPolicy < ApplicationPolicy
    def create?
        user.role == 'admin'
    end

    def destroy?
        user.role == 'admin'
    end

    def update?
        user.role == 'admin'
    end

end