class CreateFilms < ActiveRecord::Migration
  def change
    create_table :films do |t|
      t.string :title
      t.text :description
      t.string :thumbnail

      t.timestamps
    end
  end
end
