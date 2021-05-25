class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken
        include Pundit


        # reemplaza la convencion de current_user con current_api_user
        def pundit_user
                current_api_user
        end

        rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

        private

        def user_not_authorized
                render json: {"error":"No tiene permisos de administrador"}, status: 401
        end

end
