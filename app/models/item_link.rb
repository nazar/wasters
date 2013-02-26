class ItemLink < ActiveRecord::Base

  belongs_to :item
  belongs_to :link, :polymorphic => true

  #consts

  LinkTypeRecipe = 1


  #scopes
  named_scope :recipes, :conditions =>  {:item_link_type => ItemLink::LinkTypeRecipe}

  named_scope :item_ordered, {:joins => 'inner join items on items.id = item_links.item_id', :select => 'item_links.*',
                              :order => 'items.title'}
  named_scope :by_level_and_name, {:joins => 'inner join items on items.id = item_links.item_id', :select => 'item_links.*',
                                   :order => 'item_links.qty, items.title'}

  #class methods

  def self.item_links_from_hash(item_links_hash, item_links_type, force = false)
    unless item_links_hash.blank?
      item_links_hash.inject([]) do |attributes, item| #item is an array
        unless (item.last.delete(:link_id_new_value) == 'true')
          item.last.merge!(:item_link_type => item_links_type) if item_links_type > 0
          item.last.merge!(:id => item.first) if (item.first.to_i > 0) || force
          item.last.merge!(:_delete => 'true') if (item.last[:qty].to_i == 0) && (item.first.to_i > 0)
          attributes << item.last
        else
          attributes
        end
      end
    else
      []
    end
  end

  #instance methods

  def link_title
    unless link.nil?
      if link.respond_to?('name')
        result = link.name
      elsif link.respond_to?('title')
        result = link.title
      end
      result
    end
  end
  

end
