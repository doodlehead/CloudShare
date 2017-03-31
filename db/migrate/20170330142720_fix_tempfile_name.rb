class FixTempfileName < ActiveRecord::Migration[5.0]
  def change
    remove_column :assets, :Tempfile, :boolean, default: false
    add_column :assets, :tempfile, :boolean, default: false
  end
end
