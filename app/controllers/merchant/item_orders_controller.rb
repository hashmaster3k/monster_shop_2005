class Merchant::ItemOrdersController < Merchant::BaseController
  def update
    io = ItemOrder.find(params[:id])
    io.update_attribute(:order_status, 'fulfilled')
    item = Item.find(io.item_id)
    item.update_quantity_purchased(io.quantity)
    flash[:success] = "Item is now fulfilled"
    redirect_to "/merchant/orders/#{io.order_id}"
  end
end
