class CreateAnimeMaps < ActiveRecord::Migration
  def change
    create_table :anime_maps do |t|
      t.string :week
      t.string :title
      t.string :now_episode
      t.string :time

      t.timestamps
    end
  end
end
