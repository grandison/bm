class AddVkGroupLinkToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :vk_group_link, :string
  end
end
