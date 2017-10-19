class ChangeYearToBeIntegerInFilms < ActiveRecord::Migration[5.1]
  def change
    change_column :films, :year, 'integer USING CAST(year AS integer)'
  end
end
