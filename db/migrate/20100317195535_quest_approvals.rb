class QuestApprovals < ActiveRecord::Migration

  def self.up
    add_column :quests, :approved_by, :integer
    add_column :quests, :approved_at, :datetime
  end

  def self.down
    remove_column :quests, :approved_by
    remove_column :quests, :approved_at
  end

end
