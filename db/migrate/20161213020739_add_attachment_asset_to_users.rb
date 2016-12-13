class AddAttachmentAssetToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :asset
    end
  end

  def self.down
    remove_attachment :users, :asset
  end
end
