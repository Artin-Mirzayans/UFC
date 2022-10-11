class ApplicationController < ActionController::Base
  include Pagy::Backend
  
  before_action :authenticate_user!, except:[:edit_user_registration]
  helper_method :is_admin_or_mod?, :is_admin?

  def is_admin?
    current_user.admin?
  end

  def is_admin_or_mod?
    is_admin? || current_user.moderator?
  end

  def authorize_admin!
    redirect_to events_path unless is_admin?
  end

  def authorize_admin_or_mod!
    redirect_to events_path unless is_admin_or_mod?
  end

  private
  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
