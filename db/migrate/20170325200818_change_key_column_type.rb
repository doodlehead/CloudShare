class ChangeKeyColumnType < ActiveRecord::Migration[5.0]
  def change
    remove_column :keys, :kFile, :text
    remove_column :keys, :iv, :text
    
    add_column :keys, :ekey, :blob
    add_column :keys, :iv, :blob
    
    remove_column :users, :public_key, :text
    remove_column :users, :eprivate_key, :text
    
    add_column :users, :public_key, :blob
    add_column :users, :eprivate_key, :blob
  end
end
