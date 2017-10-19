class AddColumnToFilms < ActiveRecord::Migration[5.1]
  def change
    add_column :films, :kinopoisk_id, :string
  end
end
