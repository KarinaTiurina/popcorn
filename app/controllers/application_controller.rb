class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user_can_edit?

  def current_user_can_edit?(model)
    user_signed_in? && (
    model.user == current_user ||
        (model.try(:event).present? && model.event.user == current_user)
    )
  end
end
