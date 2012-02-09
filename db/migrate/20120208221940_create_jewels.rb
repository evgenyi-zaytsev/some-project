class CreateJewels < ActiveRecord::Migration
  def change
    create_table :jewels do |t|
      t.string :title
      t.string :img_url
      t.text :description
      t.integer :user_id

      t.timestamps
    end
  end
end
