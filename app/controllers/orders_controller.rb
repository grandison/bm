# -*- encoding : utf-8 -*-
class OrdersController < ApplicationController
  def new
    @main_page = true
    @order = Order.new
  end

  def create
    @with_order = params[:commit].present?
    @order = Order.create(params[:order].permit(:vk_city_id, :sex, :vk_group_link))
    unless @with_order
      @search = VkAccount.search(@order)
      if @search
        @count = @search.count
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def show
    @order = Order.find_by_plug(params[:id])
  end

  def info
    @order = Order.find_by_plug(params[:order_id])
    @count = VkAccount.search(@order).count
  end

  def boom
    @seller = Seller.find_by_code(params[:saller_code])
    @order = Order.find_by_plug(params[:order_id])
    if @seller.limit && @seller.limit <= 0
      @error = true
    else
      @order.generate!
      if @seller.limit
        @seller.limit -= VkAccount.search(@order).count
        @seller.save
      end
    end
  end

  def boom_with_names
    @seller = Seller.first
    @order = Order.find_by_plug(params[:order_id])
    @order.generate_with_names!
    render action: "boom"
  end

  def generate_full
    @order = Order.find_by_plug(params[:order_id])
    @order.generate_full!
    render action: "boom"
  end
end
