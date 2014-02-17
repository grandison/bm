class AddIndexOnVkIdToVkAccounts < ActiveRecord::Migration
  def change
    add_index :vk_accounts, :vk_id
  end
end
