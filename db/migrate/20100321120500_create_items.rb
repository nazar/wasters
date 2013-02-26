class CreateItems < ActiveRecord::Migration

  def self.up
    create_table :items do |t|
      t.integer :user_id, :updated_by
      t.integer :views_count, :comments_count, :default => 0
      t.integer :category, :level
      t.string :title, :cached_tag_list, :limit => 250
      t.float :weight, :vendor_buy_price, :vendor_sell_price
      t.text :description
      t.timestamps
    end
    add_index :items, :user_id
  end

  def self.down
    drop_table :items
  end
end
