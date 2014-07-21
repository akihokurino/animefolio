class AddIsNewToFilms < ActiveRecord::Migration
  def change
    add_column :films, :is_new, :boolean, default: false
  end
end
