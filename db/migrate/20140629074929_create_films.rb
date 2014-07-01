class CreateFilms < ActiveRecord::Migration
  def change
    create_table :films do |t|
      t.string :title
      t.text :description
      t.string :thumbnail
      t.string :first_letter
      t.boolean :recent
      t.boolean :popular

      t.timestamps
    end
  end
end
