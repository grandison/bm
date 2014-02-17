class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :plug
      t.integer :vk_group_id
      t.string :sex
      t.integer :age_from
      t.integer :age_to
      t.integer :vk_city_id

      t.timestamps
    end
  end
end
