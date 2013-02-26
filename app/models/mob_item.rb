class MobItem < ActiveRecord::Base

  belongs_to :mob
  belongs_to :item

  #consts

  ItemTypeSell    = 1
  ItemTypeDrop    = 2
  ItemTypeSkin    = 3
  ItemTypeHarvest = 4
  ItemTypeMine    = 5


  acts_as_revisable  

  #callbacks

  before_update :set_mob_item_revisable_state

  #scopes
  named_scope :sells, :conditions => {:mob_item_type => MobItem::ItemTypeSell, :revisable_is_current => 1}
  named_scope :drops, :conditions => {:mob_item_type => MobItem::ItemTypeDrop, :revisable_is_current => 1}
  named_scope :skins, :conditions => {:mob_item_type => MobItem::ItemTypeSkin, :revisable_is_current => 1}
  named_scope :harvests, :conditions => {:mob_item_type => MobItem::ItemTypeHarvest, :revisable_is_current => 1}
  named_scope :mines, :conditions => {:mob_item_type => MobItem::ItemTypeMine, :revisable_is_current => 1}
  named_scope :monsters, :conditions => {:mob_item_type => [MobItem::ItemTypeDrop, MobItem::ItemTypeSkin], :revisable_is_current => 1} 

  named_scope :item_ordered, {:joins => 'inner join items on items.id = mob_items.item_id', :select => 'mob_items.*',
                              :order => 'items.title'}

  #class methods

  def self.item_types
    {MobItem::ItemTypeSell => 'sell', MobItem::ItemTypeDrop => 'drop', MobItem::ItemTypeHarvest => 'harvest',
     MobItem::ItemTypeSkin => 'skin', MobItem::ItemTypeMine => 'mine'}
  end

  def self.frequency_types
    {1 => 'always', 2 => 'often', 3 => 'scarcely', 4 => 'rare'}
  end


  #given a mob_type will return item types applicable to that mob type
  def self.item_types_by_mob
    {
      Mob::MobTypeMob      => [MobItem::ItemTypeDrop, MobItem::ItemTypeSkin],
      Mob::MobTypeMerchant => [MobItem::ItemTypeSell],
      Mob::MobTypeNode     => [MobItem::ItemTypeHarvest],
      Mob::MobTypeMine     => [MobItem::ItemTypeMine]
    }
  end

  #given a POST hash will convert to array or hashes
  def self.params_to_mob_items_type(items_params, item_type = 0, force = false)
    unless items_params.blank?
      items_params.inject([]) do |attributes, item| #item is an array
        unless (item.last.delete(:item_id_new_value) == 'true')
          item.last.merge!(:mob_item_type => item_type) if item_type > 0
          item.last.merge!(:id => item.first)  if (item.first.to_i > 0) || force
          item.last.merge!(:_delete => 'true') if (item.last[:quantity].to_i == 0) && (item.first.to_i > 0)
          attributes << item.last
        else
          attributes
        end
      end
    else
      []
    end
  end

  def self.params_hash_to_array(params)
    MobItem.params_to_mob_items_type(params[:drop], MobItem::ItemTypeDrop) +
    MobItem.params_to_mob_items_type(params[:skin], MobItem::ItemTypeSkin) +
    MobItem.params_to_mob_items_type(params[:sell], MobItem::ItemTypeSell) +
    MobItem.params_to_mob_items_type(params[:mine], MobItem::ItemTypeMine) +
    MobItem.params_to_mob_items_type(params[:node], MobItem::ItemTypeHarvest)
  end

  #instance methods

  def frequency_to_s
    MobItem.frequency_types[frequency].capitalize if frequency.to_i > 0
  end

  def revert_or_relink_first_revision(mob)
    if revisable_number > 1
      revert_to!(mob.reverting_to.mob_items.find_by_item_id(self.item_id).revisable_number)
      self.mob = mob
      self.save(:without_revision => true)
    else #link to previous mob revision
      self.mob_id = mob.revisions.first.id
      self.save(:without_revision => true)
    end
  end

  def item_title
    item.title unless item.blank?
  end

  private

  #mob_item not revisable if mob is not revisable
  def set_mob_item_revisable_state
    self.no_revision!(true) if mob.no_revision?
  end



end
