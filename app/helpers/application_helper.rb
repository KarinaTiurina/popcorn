module ApplicationHelper
  def user_avatar(user)
    asset_path('user.jpg')
    # if user.avatar?
    #   user.avatar.url
    # else
    #   asset_path('user.png')
    # end
  end

  def film_poster(film)
    if film.poster?
      film.poster.url
    else
      asset_path('poster.jpg')
    end
  end
end
