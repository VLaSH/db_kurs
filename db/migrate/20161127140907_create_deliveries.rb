class CreateDeliveries < ActiveRecord::Migration[5.0]
  def change
    create_table :deliveries do |t|
      t.integer :provider_id
      t.integer :product_id
      t.decimal :price
      t.integer :amount
      t.datetime :delivery_date
      t.datetime :end_date
    end
  end
end
