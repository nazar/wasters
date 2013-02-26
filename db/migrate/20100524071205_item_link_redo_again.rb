class ItemLinkRedoAgain < ActiveRecord::Migration

  def self.up
    create_table :item_links do |t|
      t.integer :item_id, :link_id, :item_link_type
      t.string :link_type, :limit => 50
      t.float :qty, :default => 0
      t.timestamps
    end
    add_index :item_links, :item_id
    add_index :item_links, :link_id
  end

  def self.down
    drop_table :item_links
  end

end
