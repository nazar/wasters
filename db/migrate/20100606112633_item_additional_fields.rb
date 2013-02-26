class ItemAdditionalFields < ActiveRecord::Migration

  def self.up
    add_column :items, :requirement_id, :integer
    add_column :items, :requirement_level, :integer
    add_column :items, :not_sold, :boolean
    #now need to copy requirements from item_skills to item
    Item.transaction do
      Item.all.each do |item|
        unless item.item_skills.blank?
          unless item.item_skills.requirement.blank?
            item.requirement_id = item.item_skills.requirement.first.skilll_id
            item.requirement_level = item.item_skills.requirement.first.level
            item.save
          end
        end
      end
    end
  end

  def self.down
    remove_column :items, :requirement_id
    remove_column :items, :requirement_level
    remove_column :items, :not_sold
  end

end
