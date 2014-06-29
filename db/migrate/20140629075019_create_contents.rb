class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.integer :film_id
      t.string :title

      t.timestamps
    end
  end
end
