class AddColumnGenreToFilms < ActiveRecord::Migration[5.1]
  def change
    add_column :films, :genre, :string
  end
end
