class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method :current_user_can_edit?

  def current_user_can_edit?(model)
    user_signed_in? && (model.user == current_user)
  end

  private

  def user_not_authorized
    flash[:alert] = t('pundit.not_authorized')
    redirect_to(request.referrer || root_path)
  end
end
