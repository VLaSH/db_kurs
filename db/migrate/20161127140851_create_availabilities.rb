class CreateAvailabilities < ActiveRecord::Migration[5.0]
  def change
    create_table :availabilities do |t|
      t.integer :amount
      t.datetime :end_date
      t.decimal :price
    end
  end
end
