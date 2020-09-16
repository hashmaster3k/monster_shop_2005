class Merchant::ItemsController < Merchant::BaseController
  def index
    @items = Merchant.find(current_user.merchant_id).items
  end

  def update
    @item = Item.find(params[:id])
    if @item.active?
      @item.update_attribute(:active?, false)
      flash[:notice] = "#{@item.name} is no longer for sale."
    else
      @item.update_attribute(:active?, true)
      flash[:notice] = "#{@item.name} is now available for sale."
    end
    redirect_to "/merchant/items"
  end
end
