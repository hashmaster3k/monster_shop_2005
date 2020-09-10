class AddQuantityPurchasedToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :quantity_purchased, :integer, default: 0, null: false
  end
end
