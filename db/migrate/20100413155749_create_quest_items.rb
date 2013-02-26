class CreateQuestItems < ActiveRecord::Migration

  def self.up
    create_table :quest_items do |t|
      t.integer :item_id, :quest_id, :link_type
      t.float :qty
      t.timestamps
    end
    add_index :quest_items, :item_id
    add_index :quest_items, :quest_id
  end

  def self.down
    drop_table :quest_items
  end
  
end
