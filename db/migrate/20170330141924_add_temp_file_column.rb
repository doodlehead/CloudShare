class AddTempFileColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :assets, :Tempfile, :boolean, default: false
  end
end
