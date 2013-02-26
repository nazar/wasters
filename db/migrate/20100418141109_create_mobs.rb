class CreateMobs < ActiveRecord::Migration

  def self.up
    create_table :mobs do |t|
      t.integer  "mob_type"
      t.integer  "difficulty"
      t.integer  "hp"
      t.string   "name",                       :limit => 100
      t.text     "description"
      t.integer  "user_id"
      t.integer  "updated_by"
      t.integer  "images_count",                              :default => 0
      t.integer  "markers_count",                             :default => 0
      t.integer  "comments_count",                            :default => 0
      t.integer  "items_count",                               :default => 0
      t.integer  "views_count",                               :default => 0
      t.integer  "revisable_original_id"
      t.integer  "revisable_branched_from_id"
      t.integer  "revisable_number"
      t.string   "revisable_name"
      t.string   "revisable_type"
      t.datetime "revisable_current_at"
      t.datetime "revisable_revised_at"
      t.datetime "revisable_deleted_at"
      t.boolean  "revisable_is_current"
      t.integer  "approved_by"
      t.datetime "approved_at"
      t.string   "melee_weakness",             :limit => 150
      t.string   "spell_weakness",             :limit => 150

      t.timestamps
    end
    add_index :mobs, :user_id
    add_index :mobs, :updated_by
    add_index :mobs, :approved_by
    add_index :mobs, :revisable_original_id
  end

  def self.down
    drop_table :mobs
  end
  
end
