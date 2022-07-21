class ApplicationController < ActionController::Base
    before_action :authenticate_user!

    helper_method :ismodoradmin?, :isadmin?

    def ismodoradmin?
        current_user.moderator? || current_user.admin?
    end

    def isadmin?
        current_user.admin?
    end

    def authorize_modoradmin!
        if !ismodoradmin?
            redirect_to root_path
        end
    end

    def authorize_admin!
        if isadmin?
            redirect_to root_path
        end
    end

end
