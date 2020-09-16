class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = Merchant.find(params[:id])
    @orders = @merchant.orders.distinct
  end

  def index

  end
end
