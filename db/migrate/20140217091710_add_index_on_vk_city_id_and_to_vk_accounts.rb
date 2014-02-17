# -*- encoding : utf-8 -*-
class AddIndexOnVkCityIdAndToVkAccounts < ActiveRecord::Migration
  def change
    add_index :vk_accounts, :vk_city_id
  end
end
