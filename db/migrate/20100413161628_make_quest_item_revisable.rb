class MakeQuestItemRevisable < ActiveRecord::Migration

  def self.up
    add_column :quest_items, :revisable_original_id, :integer
    add_column :quest_items, :revisable_branched_from_id, :integer
    add_column :quest_items, :revisable_number, :integer
    add_column :quest_items, :revisable_name, :string
    add_column :quest_items, :revisable_type, :string
    add_column :quest_items, :revisable_current_at, :datetime
    add_column :quest_items, :revisable_revised_at, :datetime
    add_column :quest_items, :revisable_deleted_at, :datetime
    add_column :quest_items, :revisable_is_current, :boolean
    #
    add_index :quest_items, :revisable_original_id
  end

  def self.down
    remove_column :quest_items, :revisable_original_id
    remove_column :quest_items, :revisable_branched_from_id
    remove_column :quest_items, :revisable_number
    remove_column :quest_items, :revisable_name
    remove_column :quest_items, :revisable_type
    remove_column :quest_items, :revisable_current_at
    remove_column :quest_items, :revisable_revised_at
    remove_column :quest_items, :revisable_deleted_at
    remove_column :quest_items, :revisable_is_current
  end
  
end
