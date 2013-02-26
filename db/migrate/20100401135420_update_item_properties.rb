class UpdateItemProperties < ActiveRecord::Migration

  def self.up
   add_column :items, :sub_category, :integer
   add_column :items, :level, :integer
   add_column :items, :condition, :integer
   add_column :items, :min_condition, :integer
  end

  def self.down
    remove_column :items, :sub_category
    remove_column :items, :level
    remove_column :items, :condition
    remove_column :items, :min_condition
  end

end
