class CreateQuests < ActiveRecord::Migration

  def self.up
    create_table :quests do |t|
      t.string :title, :published_as
      t.text :description
      t.integer :comments_count, :items_count, :views_count, :rating, :default => 0
      t.integer :level, :sector
      t.integer :previous_quest_id, :next_quest_id, :user_id, :updated_by 
      t.timestamps
    end
    add_index :quests, :title
    add_index :quests, :next_quest_id 
    add_index :quests, :previous_quest_id
  end

  def self.down
    drop_table :quests
  end

end
