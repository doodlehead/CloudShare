class CreateKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :keys do |t|
      t.text :kFile
      t.integer :owner_id
      t.text :iv
      t.integer :asset_id

      t.timestamps
    end
  end
end
