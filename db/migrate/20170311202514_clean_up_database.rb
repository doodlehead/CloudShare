class CleanUpDatabase < ActiveRecord::Migration[5.0]
  def change
    remove_column :assets, :uploaded_file_file_name, :varchar
    remove_column :assets, :uploaded_file_content_type, :varchar
    remove_column :assets, :uploaded_file_file_size, :integer
    remove_column :assets, :uploaded_file_updated_at, :datetime
    
    remove_column :users, :asset_file_name, :varchar
    remove_column :users, :asset_content_type, :varchar
    remove_column :users, :asset_file_size, :integer
    remove_column :users, :asset_updated_at, :datetime
  end
end
