class FilmPolicy < ApplicationPolicy
  def get_films?
    user.is_admin
  end

  def destroy_films?
    user.is_admin
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
