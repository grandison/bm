# -*- encoding : utf-8 -*-
class OrdersController < ApplicationController
  def new
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
    @order = Order.find_by_plug(params[:order_id])
    @order.generate!
  end

  def boom_with_names
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
