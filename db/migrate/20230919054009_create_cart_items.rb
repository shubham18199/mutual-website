class CreateCartItems < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_items do |t|
      t.references :Product, null: false, foreign_key: true
      t.references :User, null: false, foreign_key: true
      t.integer :quantity, default: 1

      t.timestamps
    end
  end
end
