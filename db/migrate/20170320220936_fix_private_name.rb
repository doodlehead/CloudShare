class FixPrivateName < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :private_key, :text
    add_column :users, :eprivate_key, :text
  end
end
