# -*- encoding : utf-8 -*-
class CreateSellers < ActiveRecord::Migration
  def change
    create_table :sellers do |t|
      t.string :name
      t.string :code
      t.integer :limit

      t.timestamps
    end

    Seller.create(name: "Бум!", code: "boom", limit: nil)
    Seller.create(name: "Булат", code: "boolat", limit: 50000)
    Seller.create(name: "Римма", code: "rimma", limit: 50000)
    Seller.create(name: "test", code: "test", limit: 10000)
  end
end
