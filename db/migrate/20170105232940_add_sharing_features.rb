class AddSharingFeatures < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :shared_files, :String
    add_column :assets, :shared_with, :String
  end
end
