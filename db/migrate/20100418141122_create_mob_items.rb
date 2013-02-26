class CreateMobItems < ActiveRecord::Migration

  def self.up
    create_table :mob_items do |t|
      t.integer  "mob_id"
      t.integer  "item_id"
      t.integer  "mob_item_type"
      t.float    "quantity"
      t.integer  "revisable_original_id"
      t.integer  "revisable_branched_from_id"
      t.integer  "revisable_number"
      t.string   "revisable_name"
      t.string   "revisable_type"
      t.datetime "revisable_current_at"
      t.datetime "revisable_revised_at"
      t.datetime "revisable_deleted_at"
      t.boolean  "revisable_is_current"
      t.integer  "frequency",                  :default => 1

      t.timestamps
    end
    add_index :mob_items, :mob_id
    add_index :mob_items, :item_id
    add_index :mob_items, :revisable_original_id
  end

  def self.down
    drop_table :mob_items
  end

end
