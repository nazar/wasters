class Mob < ActiveRecord::Base

  belongs_to :user
  belongs_to :updater, :class_name => 'User', :foreign_key => 'updated_by'
  belongs_to :approver, :class_name => 'User', :foreign_key => 'approved_by'
  

  has_many :mob_items
  has_many :items_drop, :through => :mob_items, :source => :item, :select => 'items.*, mob_items.quantity, mob_items.frequency',
           :conditions => "mob_items.revisable_is_current = 1 and mob_items.mob_item_type = #{MobItem::ItemTypeDrop}"
  has_many :items_skin, :through => :mob_items, :source => :item, :select => 'items.*, mob_items.quantity, mob_items.frequency',
           :conditions => "mob_items.revisable_is_current = 1 and mob_items.mob_item_type = #{MobItem::ItemTypeSkin}"
  has_many :items_sell, :through => :mob_items, :source => :item, :select => 'items.*, mob_items.quantity',
           :conditions => "mob_items.revisable_is_current = 1 and mob_items.mob_item_type = #{MobItem::ItemTypeSell}"
  has_many :mob_item_items, :through => :mob_items, :source => :item, :select => 'items.*, mob_items.quantity, mob_items.frequency',
           :conditions => "mob_items.revisable_is_current = 1"

  has_many :quests_given, :class_name => 'Quest', :foreign_key => 'quest_giver_id'



  acts_as_activity :user
  acts_as_taggable
  acts_as_commentable

  acts_as_revisable do
    except :comments_count, :items_count, :views_count, :markers_count, :updated_by, :approved_by, :approved_at
  end

  validates_uniqueness_of :name
  validates_presence_of :name
                                                                                                                                  

  accepts_nested_attributes_for :mob_items, :allow_destroy => true


  #consts
  MobTypeMob      = 1
  MobTypeMerchant = 2
  MobTypeNode     = 3
  MobTypeMine     = 4 #TODO check AJG email regarding mob types

  MobAllType      = 1 
  MobQuestorsType = 2

  #named scopes

  named_scope :recent, :order => 'mobs.created_at DESC'
  named_scope :quest_givers, :conditions => ["quest_giver = ?", true]

  named_scope :by_mob_type, lambda{ |mob_type|
    {:conditions => ['mob_type = ?', mob_type]}
  }
  named_scope :by_difficulty, lambda{ |difficulty|
    {:conditions => ['difficulty = ?', difficulty]}
  }
  named_scope :letter_filter, lambda{|letter|
    {:conditions => ['mobs.name like ?', "#{letter}%"]}
  }
  named_scope :name_search, lambda{|search|
    {:conditions => ['mobs.name like ?', "%#{search}%"]}
  }



  #revision callbacks
  before_revise :clear_approvals_if_not_admins!
  after_revise :revise_mob_items!
  after_revert :revert_mob_items!


  #class methods

  def self.mob_types
    {
      Mob::MobTypeMob => 'mob', Mob::MobTypeMerchant => 'merchant', Mob::MobTypeNode => 'scavenge node', Mob::MobTypeMine => 'mine'
    }
  end

  def self.mob_difficulties
    {1 => 'easy', 2 => 'moderate', 3 => 'hard', 4 => 'hellish', 5 => 'Chuck Norris'}
  end

  #returns Item and Comment activity related to items
  def self.recent_item_activity(options={})
    #first find a list of ids as we want the klass plus any comments made against THAT class
    activity_ids = Activity.find_by_sql <<-EOF
       SELECT activities.id FROM `activities`
       LEFT JOIN users ON users.id = activities.user_id
       inner join comments on comments.id = activities.item_id and activities.item_type = 'Comment'
       inner join mobs on mobs.id = comments.commentable_id and comments.commentable_type = 'Mob' WHERE (users.activated_at IS NOT NULL)
         union
       SELECT activities.id FROM `activities`
       LEFT JOIN users ON users.id = activities.user_id
       inner join mobs on mobs.id = activities.item_id and activities.item_type = 'Mob' WHERE (users.activated_at IS NOT NULL)
    EOF
    #use given IDs as required
    Activity.recent.scoped({ :conditions => {:id => activity_ids}}.merge(options))
  end


  def self.mob_alphabet
    Mob.find(:all, :select => 'ucase(left(name, 1)) a, count(id) c', :group => 'left(name, 1)').inject({}) do |out, mob|
      out.merge(mob.a => mob.c)
    end
  end
  

  #instance methods

  def mob_item_type_to_s
    Mob.mob_types[mob_type] if mob_type.to_i > 0
  end

  def difficulty_to_s
    Mob.mob_difficulties[difficulty]  if difficulty.to_i > 0
  end

  def title
    name
  end

  def hit
    self.views_count += 1
  end

  def hit!
    hit
    save
  end

  def mob_items_verb
    case mob_type
      when Mob::MobTypeMerchant
        'sells'
      when Mob::MobTypeMine
        'mines'
      when Mob::MobTypeNode
        'harvests'
      else
        ''
    end
  end

  def mob_qty_name
    case mob_type
      when Mob::MobTypeMerchant
        'price'
      when Mob::MobTypeMine
        'quantity'
      when Mob::MobTypeNode
        'quantity'
      else
        ''
    end
  end

  #seo
  def to_param
    id.to_s << "-" << name.parameterize
  end

  #for comments
  def owner
    user
  end

  def quick_coords_to_xy_coords(params)
    unless params.blank?
      if ( /=(\d+),(?:\s)*(\d+)/ =~ params) == 3
        self.coords_x =  Regexp.last_match(1)
        self.coords_y =  Regexp.last_match(2)
      end
    end
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

  def revise_mob_items!
    if !is_reverting?
      self.mob_items.each(&:revise!)
    end
  end

  def revert_mob_items!
    if is_reverting?
      self.mob_items.each{ |item| item.revert_or_relink_first_revision(self)}
    end
  end

  

end
