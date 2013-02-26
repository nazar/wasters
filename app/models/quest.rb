class Quest < ActiveRecord::Base

  acts_as_activity :user
  acts_as_taggable
  acts_as_commentable
  acts_as_list :scope => :quest_group_id

  acts_as_revisable do
    except :comments_count, :items_count, :views_count, :rating
  end

  belongs_to :user
  belongs_to :updater, :class_name => 'User', :foreign_key => 'updated_by'
  belongs_to :approver, :class_name => 'User', :foreign_key => 'approved_by'
  belongs_to :quest_group
  belongs_to :quest_giver, :class_name => 'Mob', :foreign_key => 'quest_giver_id'

  has_many :favorites, :as => :favoritable, :dependent => :destroy

  has_many :quest_items
  has_many :items_handin, :through => :quest_items, :source => :item, :select => 'items.*, quest_items.qty',
           :conditions => "quest_items.revisable_is_current = 1 and quest_items.link_type = #{QuestItem::LinkTypeHandin}"
  has_many :items_reward, :through => :quest_items, :source => :item, :select => 'items.*, quest_items.qty',
           :conditions => "quest_items.revisable_is_current = 1 and quest_items.link_type = #{QuestItem::LinkTypeReward}"

  validates_presence_of :title, :description
  validates_presence_of :faction_type, :if => Proc.new { |quest| quest.faction.to_i > 0 },
                        :message => 'Faction Type cannot be blank when specifying Faction Rewards'
  validates_uniqueness_of :title
  validates_numericality_of :ap, :chips, :experience, :faction, :greater_than_or_equal => 0,
                            :only_integer => true, :allow_nil => true
  validates_numericality_of :level, :only_integer => true, :greater_than => 0,
                            :less_than_or_equal_to => 46, :message => 'Must be a number between 1 and 46'

  accepts_nested_attributes_for :quest_items, :allow_destroy => true


  #callbacks
  before_revise :clear_approvals_if_not_admins!
  after_revise :revise_quest_items!
  after_revert :revert_quest_items!


  #constants

  TypeSector1 = 1
  TypeSector2 = 2
  TypeSector3 = 3
  TypeSector4 = 4

  FactionChota       = 1
  FactionTraveller   = 2
  FactionTech        = 3
  FactioEnforcer     = 4
  FactionLightbearer = 5
  FactionVista       = 6

  #scopes

  named_scope :for_select, {:select => 'id, title'}
  named_scope :recent, :order => 'quests.created_at DESC'  

  named_scope :like_name, lambda{ |name|
    {:conditions => ['title like ?', '%'+name+'%']}
  }
  named_scope :by_quest_group, lambda{ |group_id|
    {:conditions => ['quest_group_id = ?', group_id]}
  }
  named_scope :latest, lambda{|limit|
    {:order => 'created_at DESC',  :limit => limit}
  }
  named_scope :updated, lambda{|limit|
    {:order => 'updated_at DESC',  :limit => limit}
  }
  named_scope :by_sector, lambda{ |sector|
    {:conditions => ['sector = ?', sector]}
  }
  named_scope :by_faction, lambda{ |faction|
    {:conditions => ['faction_type = ?', faction]}
  }
  named_scope :letter_filter, lambda{|letter|
    {:conditions => ['quests.title like ?', "#{letter}%"]}
  }

  #scope class methods

  #returns Item and Comment activity related to items
  def self.recent_quest_activity(options={})
    #first find a list of ids as we want the klass plus any comments made against THAT class
    activity_ids = Activity.find_by_sql <<-EOF
       SELECT activities.id FROM `activities`
       LEFT JOIN users ON users.id = activities.user_id
       inner join comments on comments.id = activities.item_id and activities.item_type = 'Comment'
       inner join quests on quests.id = comments.commentable_id and comments.commentable_type = 'Quest' WHERE (users.activated_at IS NOT NULL)
         union
       SELECT activities.id FROM `activities`
       LEFT JOIN users ON users.id = activities.user_id
       inner join quests on quests.id = activities.item_id and activities.item_type = 'Quest' WHERE (users.activated_at IS NOT NULL)
    EOF
   #use given IDs as required
    Activity.recent.scoped( {:conditions => {:id => activity_ids}}.merge(options))
  end

  #class methods

  def self.sectors
    {
       Quest::TypeSector1 => '1 - Plateau', Quest::TypeSector2 => '2 - Northfields', Quest::TypeSector3 => '3 - Kaibab Forest',
       Quest::TypeSector4 => 'sector 4'
    }
  end

  def self.faction_types
    {
      Quest::FactionChota => 'chota', Quest::FactionTraveller => 'traveller', Quest::FactionTech => 'tech',
      Quest::FactioEnforcer => 'enforcer', Quest::FactionLightbearer => 'lightbearer', Quest::FactionVista => 'vista'
    }
  end

  def self.quest_alphabet
    Quest.find(:all, :select => 'ucase(left(title, 1)) a, count(id) c', :group => 'left(title, 1)').inject({}) do |out, quest|
      out.merge(quest.a => quest.c)
    end
  end

  #instance methods

  def sector_to_s
    Quest.sectors[sector] unless sector.blank?
  end

  def faction_type_to_s
    Quest.faction_types[faction_type].humanize unless faction_type.blank?
  end

  def faction_to_s
    if faction.to_i > 0
      "#{faction.to_i} #{faction_type_to_s}"
    end
  end

  #seo
  def to_param
    id.to_s << "-" << title.parameterize
  end

  #returns all quests that are not this quest... used for previous quest select
  def all_quests_not_this
    unless self.id.blank?
      Quest.for_select.scoped(:conditions => ['id <> ?', self.id])
    else
      Quest.for_select
    end  
  end

  def previous_quest
    unless quest_group_id.blank?
      unless first?
        higher_item
      end
    end
  end

  def next_quest
    unless quest_group_id.blank?
      unless last?
        lower_item
      end
    end
  end

  #given quest_id to set as a previous quest.
  #Returns true if updates occurred on self
  def set_previous_quest(quest_id)
    #sanity check. 
    unless (quest_id == id) || (quest_id == 0)
      #check if previous quest exists and is part of quest group
      previous = Quest.find(quest_id)
      #if previous quest part of quest group then set quest_group as previous and append to end of list
      if previous.quest_group_id.blank?
        previous.no_revision!(self.no_revision?)
        previous.create_quest_group(:name => previous.title)
        previous.updated_by = self.user.id
        previous.updated_at = Time.now
        previous.save
        previous.reload #reload for position
      end
      updated = (previous.quest_group_id != self.quest_group_id) ||
              (previous.position != (self.position - 1))
      #set relations
      if updated
        self.quest_group_id = previous.quest_group_id
        self.save if new_record?
        self.insert_at(previous.position+1)
        self.save
      end
    end
  end

  #normally this would handled via quest_items_attributes = ... but neet to preprocess due to ajax combobox
  def save_items(items_hash)
    unless items_hash.blank?
      save_items = []
      #cleanup hash or delete items
      items_hash.each do |item_quest_id, quest_item|
        #check for invalid item_id
        unless (quest_item.delete(:item_id_new_value) == 'true') || (quest_item[:item_id].to_i == 0)
          quest_item.merge!(:id => item_quest_id) if item_quest_id.to_i > 0
          quest_item.merge!('_delete' => '1') unless quest_item[:qty].to_f > 0
          save_items << quest_item
        end
      end
      self.quest_items_attributes = save_items unless save_items.blank?
    end  
  end


  #get ordered list of all quests in this guest group
  def quest_chain
    unless quest_group_id.blank?
      Quest.by_quest_group(quest_group_id).ascend_by_position
    end  
  end

  def hit
    self.views_count += 1
  end

  def hit!
    hit
    save
  end

  def views_count= cnt
    self.class.record_timestamps = false
    self[:views_count] = cnt
    save!
    self.class.record_timestamps = true
  end

  #for comments
  def owner
    user
  end

  def quest_giver_name
    quest_giver.name unless quest_giver.nil?
  end

  private #callbacks

  def clear_approvals_if_not_admins!
    if !is_reverting?
      unless (updater && updater.admin_or_moderator?)
        self.approved_by = nil
        self.approved_at = nil
      end
    end
  end

  def revise_quest_items!
    if !is_reverting?
      self.quest_items.each(&:revise!)
    end
  end

  def revert_quest_items!
    if is_reverting?
      self.quest_items.each{ |item| item.revert_or_relink_first_revision(self)}
    end
  end

end
