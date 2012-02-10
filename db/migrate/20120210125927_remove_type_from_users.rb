class RemoveTypeFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :type
      end

  def down
    add_column :users, :type, :boolean
  end
end
