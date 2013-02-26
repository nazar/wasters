class AddTagsCaches < ActiveRecord::Migration

  def self.up
    add_column :mobs, :cached_tag_list, :string, {:limit => 250}
  end

  def self.down
    remove_column :mobs, :cached_tag_list
  end

end
