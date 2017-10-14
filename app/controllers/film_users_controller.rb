class FilmUsersController < ApplicationController
  before_action :set_film, only: [:create]

  def create
    @new_film_user = @film.film_users.build(film_user_params)
    @new_film_user.user = current_user

    if @new_film_user.save
     redirect_to @film, notice: 'film_user created'
    else
      render 'films/index', alert: 'error create film_user'
    end
  end

  private

  def set_film
    @film = Film.find(params[:film_id])
  end

  def film_user_params
    params.fetch(:film_user, {}).permit()
  end
end
