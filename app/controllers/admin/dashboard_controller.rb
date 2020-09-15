class Admin::DashboardController < Admin::BaseController
  def index
    @pending_orders = Order.where(order_status: "pending")
    @packaged_orders = Order.where(order_status: "packaged")
    @shipped_orders = Order.where(order_status: "shipped")
    @cancelled_orders = Order.where(order_status: "cancelled")
  end
end
