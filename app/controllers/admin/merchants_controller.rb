class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = Merchant.find(params[:id])
    @orders = @merchant.orders.distinct
  end

  def index
    @merchants = Merchant.all
  end

  def update
    merchant = Merchant.find(params[:id])
    if merchant.status == "enabled"
      merchant.update_attribute(:status, "disabled")
      merchant.disable_all_items
      flash[:success] = "#{merchant.name} is now disabled"
    else
      merchant.update_attribute(:status, "enabled")
      flash[:success] = "#{merchant.name} is now enabled"
    end
    redirect_to '/admin/merchants'
  end
end
