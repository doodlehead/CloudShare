class AddDefaultToSharing < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :shared_files, :varchar, default: ""
    change_column :assets, :shared_with, :varchar, default: ""
  end
end
