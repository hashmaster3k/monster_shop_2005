class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = Merchant.find(params[:id])
    @orders = @merchant.orders.distinct
  end

  def index
    @merchants = Merchant.all
  end
end
