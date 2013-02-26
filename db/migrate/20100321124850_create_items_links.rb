class CreateItemsLinks < ActiveRecord::Migration

  def self.up
    create_table :items_links do |t|
      t.references :the_item, :class => 'Item'
      t.references :link, :polymorphic => true
      t.timestamps
    end
    add_index :items_links, :the_item_id
    add_index :items_links, :link_id
  end

  def self.down
    drop_table :items_links
  end
  
end
