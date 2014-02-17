class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    @with_order = params[:commit].present?
    @order = Order.create(params[:order].permit(:vk_city_id, :sex, :vk_group_link))
    unless @with_order
      @count = VkAccount.search(@order).count
    end
    respond_to do |format|
      format.js
    end
  end

  def show
    @order = Order.find_by_plug(params[:id])
  end
end
