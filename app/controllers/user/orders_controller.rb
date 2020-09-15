class User::OrdersController < User::BaseController
  def index
  end

  def show
    @order = Order.find(params[:id])
  end

  def destroy
    order = Order.find(params[:id])
    order.change_status_cancel
    order.items.return_item_quantities
    flash[:success] = "Your order is now cancelled"
    redirect_to "/profile/orders/#{params[:id]}"
  end
end
