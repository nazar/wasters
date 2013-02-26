class QuestItem < ActiveRecord::Base

  belongs_to :item
  belongs_to :quest

  acts_as_revisable

  #consts

  LinkTypeReward = 1
  LinkTypeHandin = 2

  #callbacks

  before_update :set_quest_item_revisable_state

  #class methods

  def self.link_types
    {QuestItem::LinkTypeReward => 'reward', QuestItem::LinkTypeHandin => 'handin' }
  end

  #instance methods

  def revert_or_relink_first_revision(quest)
    if revisable_number > 1
      revert_to!(quest.reverting_to.quest_items.find_by_item_id(self.item_id).revisable_number)
      self.quest = quest
      self.save(:without_revision => true)
    else #link to previous quest revision
      self.quest_id = quest.revisions.first.id
      self.save(:without_revision => true)
    end
  end

  #given a POST hash will convert to array or hashes
  def self.params_to_quest_items_type(quest_params, item_type = 0, force = false)
    unless quest_params.blank?
      quest_params.inject([]) do |attributes, item| #item is an array
        unless (item.last.delete(:item_id_new_value) == 'true')
          item.last.merge!(:link_type => item_type) if item_type > 0
          item.last.merge!(:id => item.first)  if (item.first.to_i > 0) || force
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

  def item_title
    item.title unless item.nil?
  end


  private

  #quest_item not revisable if quest is not revisable
  def set_quest_item_revisable_state
    self.no_revision!(true) if quest.no_revision?
  end

end
