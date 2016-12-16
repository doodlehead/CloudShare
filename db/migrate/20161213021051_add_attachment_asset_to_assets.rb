class AddAttachmentAssetToAssets < ActiveRecord::Migration
  def self.up
    change_table :assets do |t|
      t.attachment :asset
    end
  end

  def self.down
    remove_attachment :assets, :asset
  end
end
