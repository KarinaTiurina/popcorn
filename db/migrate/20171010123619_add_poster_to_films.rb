class AddPosterToFilms < ActiveRecord::Migration[5.1]
  def change
    add_column :films, :poster, :string
  end
end
