class ChangeCartItemReferences < ActiveRecord::Migration[7.0]
  def change
    remove_index :cart_items, :User_id 
    remove_index :cart_items, :Product_id 
    rename_column :cart_items, :User_id, :user_id, null: false, foreign_key: true
    rename_column :cart_items, :Product_id, :product_id, null: false, foreign_key: true
  end
end
