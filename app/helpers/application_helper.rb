module ApplicationHelper
  def user_avatar(user)
    asset_path('user.jpg')
    # if user.avatar?
    #   user.avatar.url
    # else
    #   asset_path('user.png')
    # end
  end
end
