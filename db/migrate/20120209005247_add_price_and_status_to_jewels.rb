class AddPriceAndStatusToJewels < ActiveRecord::Migration
  def change
    add_column :jewels, :price, :number

    add_column :jewels, :status, :integer

  end
end
