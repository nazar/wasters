class CreateItemSchematics < ActiveRecord::Migration

  def self.up
    create_table :item_schematics do |t|
      t.integer :assembley, :root_item_id, :item_id, :user_id, :updated_by
      t.integer :level, :default => 0
      t.float :qty, :default => 0.0
      t.timestamps
    end
    add_index :item_schematics, :assembley
    add_index :item_schematics, :root_item_id
    add_index :item_schematics, :item_id
    add_index :item_schematics, :user_id
    add_index :item_schematics, :updated_by
  end

  def self.down
    drop_table :item_schematics
  end

end
