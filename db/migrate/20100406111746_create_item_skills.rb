class CreateItemSkills < ActiveRecord::Migration
  def self.up
    create_table :item_skills do |t|
      t.integer :item_id, :skilll_id, :level, :link_type
      t.timestamps
    end
    add_index :item_skills, :item_id
    add_index :item_skills, :skilll_id
  end

  def self.down
    drop_table :item_skills
  end
end
