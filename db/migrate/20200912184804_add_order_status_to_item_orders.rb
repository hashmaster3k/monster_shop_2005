class AddOrderStatusToItemOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :item_orders, :order_status, :string, default: "unfulfilled"
  end
end
