class QuestRewards < ActiveRecord::Migration

  def self.up
    add_column :quests, :ap, :integer
    add_column :quests, :chips, :integer
    add_column :quests, :experience, :integer
    add_column :quests, :faction, :integer
    add_column :quests, :faction_type, :integer
  end

  def self.down
    remove_column :quests, :ap
    remove_column :quests, :chips
    remove_column :quests, :experience
    remove_column :quests, :faction
    remove_column :quests, :faction_type
  end

end
