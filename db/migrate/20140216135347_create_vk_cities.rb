class CreateVkCities < ActiveRecord::Migration
  def change
    create_table :vk_cities do |t|
      t.integer :vk_city_id
      t.string :name

      t.timestamps
    end
  end
end
