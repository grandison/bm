class CreateVkAccounts < ActiveRecord::Migration
  def change
    create_table :vk_accounts do |t|
      t.string :email
      t.integer :vk_id
      t.integer :vk_city_id
      t.string :sex
      t.date :birthdate

      t.timestamps
    end
  end
end
