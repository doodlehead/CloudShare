class AddDefaultToSharing < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :shared_files, :varchar, default: ""
    add_column :assets, :shared_with, :varchar, default: ""
  end
end
