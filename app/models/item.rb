class Item < ActiveRecord::Base

  has_many :schematic_roots, :class_name => 'ItemSchematic', :foreign_key => 'root_item_id'
  has_many :item_schematics

  has_many :component_for, :class_name => 'ItemSchematic', :foreign_key => 'item_id'
  has_many :component_for_items, :through => :component_for, :source => :root_item, :uniq => true

  has_many :item_skills
  has_many :skills, :through => :item_skill

  has_many :quest_items
  has_many :item_quests, :through => :quest_items, :source => :quest,
           :select => 'quests.*, quest_items.qty, quest_items.link_type',
           :conditions => "quest_items.revisable_is_current = 1"

  has_many :mob_items
  has_many :mobs, :through => :mob_items

  MOB_ITEM_DEFAULT = {:source => :mob, :through => :mob_items, :select => 'mobs.*, mob_items.quantity, mob_items.frequency, mob_items.mob_item_type'}
  has_many :merchants, {:scope => :sells}.merge(MOB_ITEM_DEFAULT)
  has_many :monsters, {:scope => :monsters}.merge(MOB_ITEM_DEFAULT)
  has_many :nodes, {:scope => :harvests}.merge(MOB_ITEM_DEFAULT)
  has_many :mines, {:scope => :mines}.merge(MOB_ITEM_DEFAULT)

  has_many :item_links
  has_many :recipe_items, :through => :item_links, :scope => :recipes

  has_many :favorites, :as => :favoritable, :dependent => :destroy

  has_one :item_stat_armour
  has_one :item_stat_weapon

  belongs_to :user
  belongs_to :updater, :class_name => 'User', :foreign_key => 'updated_by'

  belongs_to :requirement, :class_name => 'Skilll', :foreign_key => 'requirement_id'

  validates_uniqueness_of :title
  validates_presence_of :title
  validates_numericality_of :craft_time_m, :allow_nil => true, :less_than => 60, :greater_than_or_equal_to => 0
  validates_numericality_of :craft_time_s, :allow_nil => true, :less_than => 60, :greater_than_or_equal_to => 0


  accepts_nested_attributes_for :item_stat_armour, :item_stat_weapon, :item_links,
                                :allow_destroy => true

  acts_as_activity :user
  acts_as_taggable
  acts_as_commentable

  has_attached_file :icon,
                    :styles => { :original => ['72x72#', "jpg"]  },
                    :default_style => :original,
                    :default_url => "/images/missing.png",
                    :convert_options => { :all => "-strip" }
  

  ItemCatCraftable    = 1
  ItemCatArmour       = 2
  ItemCatWeapon       = 3
  ItemCatAmmo         = 4
  ItemCatFood         = 5
  ItemCatManualSkill  = 6
  ItemCatManualCraft  = 7
  ItemResourceComp    = 8
  ItemResourceTrash   = 9
  ItemResourceMission = 10

  #named scopes

  named_scope :recent, :order => 'items.created_at DESC'

  named_scope :letter_filter, lambda{|letter|
    {:conditions => ['items.title like ?', "#{letter}%"]}
  }
  named_scope :name_search, lambda{|search|
    {:conditions => ['items.title like ?', "%#{search}%"]}
  }

  #scoped class method

  def self.by_type_and_sub(cat, sub, options={})
    items = Item.scoped(:conditions => ['items.category = ?', cat])
    if cat == Item::ItemCatWeapon
      items = items.scoped(:joins => "inner join item_stat_weapons isw on items.id = isw.item_id")
    elsif cat == Item::ItemCatArmour
      items = items.scoped(:joins => "inner join item_stat_armours isa on items.id = isa.item_id")
    end
    unless sub.blank?
      if cat == Item::ItemCatWeapon
        items = items.scoped(:conditions => ['isw.weapon_type = ?', sub.to_i])
      elsif cat == Item::ItemCatArmour
        items = items.scoped(:conditions => ['isa.slot like ?',"%#{sub}%"])
      else
        raise 'invalid sub for item type'
      end
    end
    if options[:includes]
      if cat == Item::ItemCatWeapon
        items = items.scoped(:include => {:item_stat_weapon => :ammo_item})
      elsif cat == Item::ItemCatArmour
        items = items.scoped(:include => :item_stat_armour)
      end
    end
    items
  end

  #returns Item and Comment activity related to items
  def self.recent_item_activity(options={})
    #first find a list of ids as we want the klass plus any comments made against THAT class
    activity_ids = Activity.find_by_sql <<-EOF
       SELECT activities.id FROM `activities`
       LEFT JOIN users ON users.id = activities.user_id
       inner join comments on comments.id = activities.item_id and activities.item_type = 'Comment'
       inner join items on items.id = comments.commentable_id and comments.commentable_type = 'Item' WHERE (users.activated_at IS NOT NULL)
         union
       SELECT activities.id FROM `activities`
       LEFT JOIN users ON users.id = activities.user_id
       inner join items on items.id = activities.item_id and activities.item_type = 'Item' WHERE (users.activated_at IS NOT NULL)
    EOF
    #use given IDs as required
    Activity.recent.scoped({ :conditions => {:id => activity_ids}}.merge(options))
  end

  #class methods

  def self.categories
    {Item::ItemCatCraftable => 'craftable', Item::ItemCatArmour => 'armour', Item::ItemCatWeapon => 'weapon',
           Item::ItemCatAmmo => 'ammunition', Item::ItemCatFood => 'food',
           Item::ItemCatManualSkill => 'skill manual', Item::ItemCatManualCraft => 'crafting manual',
           Item::ItemResourceComp => 'resource component', Item::ItemResourceTrash => 'trash',
           Item::ItemResourceMission => 'mission' }
  end

  def self.item_cat_sub_type(category, sub)
    case category
      when Item::ItemCatWeapon
        ItemStatWeapon.weapon_types[sub.to_i]
      when Item::ItemCatArmour
        ItemStatArmour.slots[sub]
      else
        ''
    end
  end

  #given an item_id returns the base assembley of that item
  def self.item_base_assembley_id(item_id)
    Item.find(item_id).assembly_from_assemblies
  end

  def self.sub_by_category_to_s(category, sub)
    if category == Item::ItemCatWeapon
      ItemStatWeapon.weapon_sub_types[sub]
    elsif category == Item::ItemCatArmour
      ItemStatArmour.slots[sub]
    end
  end

  def self.item_alphabet
    Item.find(:all, :select => 'ucase(left(title, 1)) a, count(id) c', :group => 'left(title, 1)').inject({}) do |out, item|
      out.merge(item.a => item.c)
    end
  end



  #instance methods

  def category_to_s
    Item.categories[category] || ''
  end

  #seo
  def to_param
    id.to_s << "-" << title.parameterize
  end

  #for comments
  def owner
    user
  end

  #presents either of item_stat_armour or item_stat_weapon depending on item category
  def stats
    case category
      when Item::ItemCatArmour
        item_stat_armour || build_item_stat_armour
      when Item::ItemCatWeapon
        item_stat_weapon || build_item_stat_weapon
    end
  end

  def save_schematics(schematics_hash, user_id)
    ass_cache = []
    schematics_hash.each do |schematic_id, schematic_hash|
      next if schematic_hash.delete('item_id_new_value') == 'true' #bail as this is invalid entry
      if schematic_hash[:qty].to_f > 0
        ItemSchematic.save_item_schematics(self, schematic_id, schematic_hash) do |schematic|
          ass_cache << schematic.item.assemblies
          schematic.user_id = user_id
        end
      else
        ItemSchematic.check_and_delete(schematic_id, schematic_hash[:qty].to_i)
      end
    end
    #cache assemblies
    self.assemblies = ass_cache.uniq.join(',')
    self.has_schematic = true unless self.assemblies.blank?
  end

  def save_skills(skills_hash)
    skills_hash.each do |skill_link_type, item_skill_hash|
      item_skill_id = item_skill_hash[:id].to_a.flatten.first.to_i
      skill_id      = item_skill_hash[:id].to_a.flatten.last.to_i
      level         = item_skill_hash[:level].to_a.flatten.last.to_i
      if skill_id > 0
        #find or init
        item_skill = item_skills.find_by_id(item_skill_id) || item_skills.build
        #save
        item_skill.skilll_id = skill_id
        if skill_id > 0
          item_skill.link_type = skill_link_type.to_i
          item_skill.level     = level
        else
          item_skill.link_type = nil
          item_skill.level     = nil
        end
        item_skill.save
      end  
    end
  end

  def save_damages(damages_hash)
    stats.damage = damages_hash.inject([]) do |result, damage|
      if damage.last.to_i > 0
        result << "#{damage.first}:#{damage.last}"
      else
        result
      end
    end.join(',')
    stats.save
  end

  def save_recipes(recipes_hash)
    self.item_links_attributes = ItemLink.item_links_from_hash(recipes_hash, ItemLink::LinkTypeRecipe)
  end

  def save_armour_slots(slots_hash)
    if category.to_i == Item::ItemCatArmour
      stats.slot = slots_hash.inject([]){|slots, slot| slots << slot.first}.join(',')
      stats.save
    end
  end

  #returns the topmost assembley for given item
  def assembly_from_assemblies
    unless assemblies.blank?
      a = assemblies.split(',').select{|a| a.split(':').last.to_i == id}.collect{|a| a.split(';').first}.first
      a.nil? ? nil : a.to_i
    end
  end

  def hit!(do_save = false)
    self.views_count += 1
    self.save if do_save
  end

  def views_count= cnt
    self.class.record_timestamps = false
    self[:views_count] = cnt
    save!
    self.class.record_timestamps = true
  end

  #returns the full build schematic for a given item as an array of subitems
  def full_schematics_hash

    def sub_weight_and_cost(subs, item, do_item = true)
      if subs.blank?
        wgt = item.weight
        cost = item.vendor_sell_price
        build = item.crafting_seconds
      else
        wgt = cost = build = 0
        subs.each_value do |sub|
          wgt  += sub[:wgt].to_f  * sub[:qty].to_f
          cost += sub[:cost].to_f * sub[:qty].to_f
          build += sub[:build].to_f * sub[:qty].to_f
        end
      end
      result = {:wgt => wgt, :cost => cost, :build => build}
      if item and do_item
        result.merge(:item => item, :item_id => item.id)
      else
        result
      end
    end

    def item_assembley(item_schematic, level, items, assemblies, level_info = true)
      unless assemblies[item_schematic.item_id].blank?
        assembley = assemblies[item_schematic.item_id].inject({}) do |subs, schematic|
          comp_hash = component_to_hash(schematic, level, items)
          unless assemblies[schematic.item_id].blank?
            comp_hash.merge!( item_assembley(schematic, level + 1, items, assemblies, false) )
            #item has subs...cost and wgt and recalc based on subs
            comp_hash.merge!( sub_weight_and_cost(comp_hash[:assembley], nil, false) )
          end
          subs.merge(schematic.id => comp_hash)
        end
      end
      if level_info && items[item_schematic.item_id]
        result = sub_weight_and_cost(assembley, items[item_schematic.item_id] )
        result[:qty] = item_schematic.qty
      else
        result = {}
      end
      result[:assembley] = assembley unless assembley.nil?
      result #return it
    end

    def component_to_hash(item_schematic, level, items)
      {
        :item_schematic_id => item_schematic.id,
        :item_id => item_schematic.item_id, #TODO not need once we have item obj
        :level => level,
        :qty => item_schematic.qty,
      }.merge(sub_weight_and_cost(nil, items[item_schematic.item_id]))
    end
    #item knows what assembleys make its schematic... load all ItemSchematic by assemblies
    item_components = assemblies.blank? ? [] : ItemSchematic.by_assemblies(assemblies)
    #build lookup tables
    assemblies = item_components.inject({}) do |asses, component|
      if asses[component.root_item_id].nil?
        asses.merge(component.root_item_id => [component])
      else
        asses.merge(component.root_item_id => (asses[component.root_item_id] << component))
      end
    end
    #item_components is the complete schematic... extract all items from schematic for x-reference
    all_items = (item_components.collect{|s| s.item_id} + item_components.collect{|s| s.root_item_id}).uniq
    refed_items = Item.find(all_items).inject({}) do |items, item|
      items.merge(item.id => item)
    end
    #iterate through item_components array and build full schematic hash
    full_assembley = schematic_roots.inject({}) do |full_schematic, item_schematic|
      full_schematic.merge( item_schematic.id => item_assembley(item_schematic, 1, refed_items, assemblies) )
    end
    #final step.. construct full assembley (including top level item) and calc costs, weight
    {:assembley => full_assembley}.merge(sub_weight_and_cost(full_assembley, self))
  end

  def item_skills_type_hash
    item_skills.not_requirement.inject({})do |skills, item_skill|
      skills.merge(item_skill.link_type => item_skill)
    end
  end

  def weapon?
    category == Item::ItemCatWeapon
  end

  def damages_hash
    def damage_type_to_hash(d_type, damage)
      {:desc => ItemStatWeapon.damage_types[d_type], :damage => damage}
    end
    #only applies if this is a weapon
    if weapon?
      (item_stat_weapon.damage || '').split(',').inject({}) do |damage, damage_type|
        a_damage_type = damage_type.split(':')
        damage.merge(a_damage_type.first.to_i => damage_type_to_hash(a_damage_type.first.to_i, a_damage_type.last.to_i))
      end.reverse_merge ItemStatWeapon.damage_types.keys.inject({}){|empty, damage_type| empty.merge(damage_type => damage_type_to_hash(damage_type, 0))}
    else
      {}
    end
  end

  def crafting_seconds
    (craft_time_h.to_i * 60 * 60) + (craft_time_m.to_i * 60) + craft_time_s.to_i
  end

  def crafting_time_normal
    time = crafting_seconds
    [time/3600, time/60 % 60, time % 60].map{|t| t.to_s.rjust(2, '0')}.join(':') if time > 0
  end

  def crafting_time_adjuested
    time = (crafting_seconds.to_f * 0.75).to_i
    [time/3600, time/60 % 60, time % 60].map{|t| t.to_s.rjust(2, '0')}.join(':') if time > 0
  end

  def owner?(current_user)
    current_user && current_user.id == user_id
  end

end
