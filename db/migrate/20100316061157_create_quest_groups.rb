class CreateQuestGroups < ActiveRecord::Migration

  def self.up
    create_table :quest_groups do |t|
      t.string :name, :limit => 200
      t.timestamps
    end
    add_index :quest_groups, :name
    #update quests to add FK
    add_column :quests, :quest_group_id, :integer
    add_column :quests, :position, :integer
    add_column :quests, :cached_tag_list, :string, {:limit => 255}

    remove_column :quests, :next_quest_id
    remove_column :quests, :previous_quest_id
    remove_column :quests, :published_as
    #
    add_index :quests, :quest_group_id
  end

  def self.down
    drop_table :quest_groups
    #quests
    remove_column :quests, :quest_group_id
    remove_column :quests, :position
    remove_column :quests, :cached_tag_list

    add_column :quests, :next_quest_id, :integer
    add_column :quests, :previous_quest_id, :integer
    add_column :quests, :published_as, :string, {:limit => 255}
  end

end
