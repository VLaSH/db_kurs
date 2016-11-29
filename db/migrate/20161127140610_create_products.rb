class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :category_id
      t.date :made
      t.integer :expiration
    end
  end
end
