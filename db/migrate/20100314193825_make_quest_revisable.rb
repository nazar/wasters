class MakeQuestRevisable < ActiveRecord::Migration

  def self.up
    add_column :quests, :revisable_original_id, :integer
    add_column :quests, :revisable_branched_from_id, :integer
    add_column :quests, :revisable_number, :integer
    add_column :quests, :revisable_name, :string
    add_column :quests, :revisable_type, :string
    add_column :quests, :revisable_current_at, :datetime
    add_column :quests, :revisable_revised_at, :datetime
    add_column :quests, :revisable_deleted_at, :datetime
    add_column :quests, :revisable_is_current, :boolean
  end

  def self.down
    remove_column :quests, :revisable_original_id
    remove_column :quests, :revisable_branched_from_id
    remove_column :quests, :revisable_number
    remove_column :quests, :revisable_name
    remove_column :quests, :revisable_type
    remove_column :quests, :revisable_current_at
    remove_column :quests, :revisable_revised_at
    remove_column :quests, :revisable_deleted_at
    remove_column :quests, :revisable_is_current
  end
  
end
