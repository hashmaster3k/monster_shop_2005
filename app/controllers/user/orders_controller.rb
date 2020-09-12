class User::OrdersController < User::BaseController
  def index

  end

  def show
    @order = Order.find(params[:id])
  end
end
