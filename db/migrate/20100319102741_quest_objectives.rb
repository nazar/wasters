class QuestObjectives < ActiveRecord::Migration

  def self.up
    add_column :quests, :objective, :text
  end

  def self.down
    remove_column :quests, :objective
  end

end
