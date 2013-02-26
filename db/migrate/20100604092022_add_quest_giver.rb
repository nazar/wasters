class AddQuestGiver < ActiveRecord::Migration

  def self.up
    add_column :quests, :quest_giver_id, :integer
    add_index :quests, :quest_giver_id
    #also for mobs
    add_column :mobs, :quest_giver, :boolean
  end

  def self.down
    remove_column :quests, :quest_giver_id
    remove_column :mobs, :quest_giver
  end

end
