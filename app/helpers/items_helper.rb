module ItemsHelper

  def category_select(item)
    select_tag 'item[category]', options_for_select(order_key_value_hash(Item.categories), item.category), {:id => 'item_cat_select'}
  end

  def item_stats_by_category(item, item_links=[])
    case item.category
      when Item::ItemCatArmour
        render :partial => 'item_stat_armours/form_stats'
      when Item::ItemCatWeapon
        render :partial => 'item_stat_weapons/form_stats'
      when Item::ItemCatManualCraft
        render :partial => 'item_links/edit_verbs', :locals => {:item_links => item_links, :verb => 'recipe', :qty_desc => 'Level'}
      else
        render :text => '&nbsp;' #need to send backsomething for the onupdate to work
    end
  end

  def setup_armour_stats(item)
    item.item_stat_armour || item.build_item_stat_armour
  end

  def setup_weapon_stats(item)
    item.item_stat_weapon || item.build_item_stat_weapon
  end

  def item_properties(item)
    case item.category
      when Item::ItemCatArmour
        render :partial => 'item_stat_armours/stats', :locals => {:stat => item.stats}
      when Item::ItemCatWeapon
        render :partial => 'item_stat_weapons/stats', :locals => {:stat => item.stats}
    end
  end

  def weapon_sub_type_options_for(weapon_type)
    subs = ItemStatWeapon.sub_types_by_weapon_type(weapon_type).inject({}) do |subtypes, subtype|
      subtypes.merge( subtype => ItemStatWeapon.weapon_sub_types[subtype] )
    end 
    subs.sort{|a,b|a[1]<=>b[1]}.collect{|c|[c.last, c.first]}
  end

  #provide skill tags depending on item type
  def item_skill_tags(item)

    def field_hash(link_type, skills_hash, skill_options)
      item_skill_id = skills_hash[link_type].nil? ? -1 : skills_hash[link_type].id
      skill_id      = skills_hash[link_type].nil? ? nil : skills_hash[link_type].skilll_id
      level         = skills_hash[link_type].nil? ? nil : skills_hash[link_type].level

      result = {:label => ItemSkill.link_types[link_type].humanize}
      if ItemSkill.skill_no_level.include?(link_type) #no lvl for this skill
        result.merge!( :tag   => select_tag( "item_skills[#{link_type}][id][#{item_skill_id}]",
                                options_for_select(skill_options, skill_id) ) )
      else
        result.merge!( :tag   => select_tag( "item_skills[#{link_type}][id][#{item_skill_id}]",
                                 options_for_select(skill_options, skill_id) ) << ' value ' <<
                                  text_field_tag("item_skills[#{link_type}][level][#{item_skill_id}]", level) )

      end
      result
    end
    #####START#####
    skills_hash   = item.item_skills_type_hash
    requirements = Skilll.ascend_by_title.ids_names.collect{|s|[s.title, s.id]}.insert(0, '')
#    modifiers = Skilll.ascend_by_title.ids_names.collect{|s|[s.title, s.id]}.insert(0, '')

    result = []

    if item.category == Item::ItemCatArmour
      result << field_hash(ItemSkill::LinkTypeMod1, skills_hash, requirements)
      result << field_hash(ItemSkill::LinkTypeMod2, skills_hash, requirements)
    end
    if item.category == Item::ItemCatWeapon
      result << field_hash(ItemSkill::LinkTypeAttack, skills_hash, requirements)
      result << field_hash(ItemSkill::LinkTypeDefence, skills_hash, requirements)
      result << field_hash(ItemSkill::LinkTypeMod1, skills_hash, requirements)
      result << field_hash(ItemSkill::LinkTypeMod2, skills_hash, requirements)
    end
    out = result.inject('') do |output, field|
      output << label_tag(field[:label]) << field[:tag]
    end
    content_tag(:div, out, :class => 'requirments')
  end

  def skills_list(item, options={})
    options.reverse_merge!({:ul_class => 'properties_list'})
    unless (item_skills = item.item_skills_type_hash).blank?
      #TODO possible refactor with inject
      lis = ''
      list = content_tag :ul, :class => options[:ul_class] do
        item_skills.sort{|a,b|ItemSkill.link_types[a.last.link_type]<=>ItemSkill.link_types[b.last.link_type]}.each do |link_type, item_skill|
          unless ItemSkill.link_types[link_type.to_i].blank?
            if ItemSkill.skill_no_level.include?(link_type.to_i)
              lis << stat_line(ItemSkill.link_types[link_type.to_i].humanize, "#{item_skill.skilll.title.humanize}")
            else
              lvl = item_skill.level > 0 ? "+#{item_skill.level}" : item_skill.level
              lis << stat_line(ItemSkill.link_types[link_type.to_i].humanize, "#{item_skill.skilll.title.humanize} #{lvl}")
            end
          end
        end
        lis
      end
      list
    end
  end

  def damages_tags(item)
    item.damages_hash.sort{|a,b| a[1][:desc] <=> b[1][:desc]}.inject("") do |fields, damage|
      fields << label_tag(damage.last[:desc].humanize) <<
                text_field_tag("item_damage[#{damage.first}]", damage.last[:damage])
    end
  end

  def damages_list(item, options={})
    options.reverse_merge!({:ul_class => 'properties_list'})
    if item.weapon?
      content_tag(:ul, :class => options[:ul_class]) do
        item.damages_hash.sort{|a,b| a[1][:desc] <=> b[1][:desc]}.inject("") do |fields, damage|
          if damage.last[:damage].to_i > 0
            fields << stat_line(damage.last[:desc].humanize, damage.last[:damage])
          else
            fields
          end  
        end
      end
    end
  end

  #builds a hash tree of items and item subtypes
  def item_type_links(item_type_id = nil)
    item_types = {}
    item_types[Item::ItemCatWeapon] = {:name => Item.categories[Item::ItemCatWeapon], :subs => ItemStatWeapon.weapon_types}
    item_types[Item::ItemCatArmour] = {:name => Item.categories[Item::ItemCatArmour], :subs => ItemStatArmour.slots}
    #get non weapon and armour types
    item_types.merge!( Item.categories.
                       select{|k,v| not [Item::ItemCatArmour, Item::ItemCatWeapon].include?(k)}.
                       inject({}){|result, category| result.merge(category.first => {:name => category.last})} )
    #convert hash to ul and li items
    list = item_types.sort{|a,b|a[1][:name] <=> b[1][:name]}.inject("") do |result, item_cat|
      item_link = link_to(item_cat.last[:name].humanize, item_cat_path(item_cat.first))
      if item_cat.last[:subs].blank?
        result << content_tag(:li, item_link)
      else #item_cat has subs.. render as ul sublist
        subs = content_tag(:ul) do
          item_cat.last[:subs].inject('') do |out, sub|
            out << content_tag(:li, link_to(sub.last.humanize, item_cat_sub_path(item_cat.first, sub.first)))
          end
        end
        li_class = item_type_id.to_i == item_cat.first.to_i ? 'open' : 'closed' 
        result << content_tag(:li, item_link << subs, :class => li_class)
      end
    end
    content_tag(:div, :id => 'item_categories', :class => 'tree') do
      content_tag(:ul, list, :class => 'jstree-default')
    end
  end

  def item_sub_type_links(cat, sub, type)
    if cat == Item::ItemCatWeapon #this applies to weapons only
      types = ItemStatWeapon.sub_types_by_weapon_type(sub).inject({}) do |out, weapon_type|
        out.merge(weapon_type => ItemStatWeapon.weapon_sub_types[weapon_type].humanize)
      end
      #generale list based on types
      list = types.sort{|a,b| a[1]<=>b[1]}.inject('') do |content, weapon_type|
        unless type == weapon_type.first
          content << content_tag(:li, link_to(weapon_type.last, item_cat_sub_type_path(cat, sub, weapon_type.first)))
        else
          content << content_tag(:li, content_tag(:strong, weapon_type.last))
        end
      end
      content_tag(:ul, list) unless list.blank?
    end
  end

  def cat_columns(category, sub, type)
    columns = []
    numerics = ['Damage', 'Delay', 'DPS', 'Range']
    if category == Item::ItemCatWeapon
      columns << ['Damage', 'Delay', 'DPS', 'Range']
      if [ItemStatWeapon::WeaponTypePistol, ItemStatWeapon::WeaponTypeRifle].include?(sub)
        columns << ['Ammo', 'AmmoS']
      elsif sub == 0
        columns.insert(0, 'Type')
      end
      columns.flatten!
      if type == 0
        columns.insert(sub == 0 ? 1 : 0, 'SubType')
      end
    elsif category == Item::ItemCatArmour
      columns << ['Slots',
                  content_tag(:span, 'BR', :title => 'Ballistic Resist'),
                  content_tag(:span, 'CR', :title => 'Crushing Resist'),
                  content_tag(:span, 'PR', :title => 'Piercing Resist'),
                  content_tag(:span, 'SR', :title => 'Slashing Resist'),
                  content_tag(:span, 'SCR', :title => 'Secondary Cold Resist'),
                  content_tag(:span, 'SFR', :title => 'Secondary File Resist')
                 ]
    end
    columns.flatten.inject('') do |out, column|
      if numerics.include?(column)
        out << content_tag(:th, column, :class => 'number')
      else
        out << content_tag(:th, column)
      end
    end
  end

  def item_cat_rows(data, category, sub, type)
    columns = []
    if category == Item::ItemCatWeapon
      columns << [data.item_stat_weapon.damages_to_s, data.item_stat_weapon.delay,
                  data.item_stat_weapon.dps, data.item_stat_weapon.max_range]
      if [ItemStatWeapon::WeaponTypePistol, ItemStatWeapon::WeaponTypeRifle].include?(sub)
        unless data.item_stat_weapon.ammo_item.blank?
          columns << [link_to(data.item_stat_weapon.ammo_item_name, item_path(data.item_stat_weapon.ammo_item_id)), data.item_stat_weapon.ammo]
        else
          columns << ['&nbsp;', '&nbsp;']
        end  
      elsif sub == 0
        columns.insert(0, link_to(data.item_stat_weapon.weapon_type_to_s.humanize, item_cat_sub_path(category, data.item_stat_weapon.weapon_type)))
      end
      columns.flatten!
      if type == 0
        columns.insert(sub == 0 ? 1 : 0, link_to(data.item_stat_weapon.sub_type_to_s.humanize,
                                  item_cat_sub_type_path(data.category, data.item_stat_weapon.weapon_type, data.item_stat_weapon.weapon_subtype)))
      end
    elsif category == Item::ItemCatArmour
      slots = data.item_stat_armour.slot_sorted_by_name_to_a.inject([]) do |links, slot|
        links << link_to(ItemStatArmour.slots_abbreviated[slot],
                         item_cat_sub_path(Item::ItemCatArmour, slot),
                         :title => ItemStatArmour.slots[slot].humanize)
      end
      columns << [slots.join(', '),
                  data.item_stat_armour.ballistic, data.item_stat_armour.crushing, data.item_stat_armour.piercing, data.item_stat_armour.slashing,
                  data.item_stat_armour.cold, data.item_stat_armour.fire]
    end
    columns.flatten.inject('') do |out, column|
      out << content_tag(:td, column)
    end
  end

  def schematic_item_title(schematic)
    unless schematic[:item].blank?
      schematic[:item].title
    end
  end

  def requirement_line(item)
    if item.requirement_id.to_i > 0
      req = if item.requirement_level.to_i > 0
        "#{item.requirement.title} - level #{item.requirement_level}"
      else
        "#{item.requirement.title}"
      end
      stat_line(:requirements.l, req)
    end
  end

  def requirement_select(item)
    options = order_key_value_hash(Skilll.ids_names.collect{|s|[s.id, s.title]}).insert(0,['',0])
    options_for_select options, item.requirement_id
  end

  def craft_seconds_to_time(craft_seconds)
    time = craft_seconds.to_i
    [time/3600, time/60 % 60, time % 60].map{|t| t.to_s.rjust(2, '0')}.join(':') if time.to_i > 0
  end

  def sort_schematic_by_item(schematics)
    schematics.sort{|a,b| (a[1][:item].nil? ? '' : a[1][:item].title.downcase) <=> (b[1][:item].nil? ? '' : b[1][:item].title.downcase)}
  end

  def armour_slot_check_boxes(armour_stat)
    slots = order_key_value_hash(ItemStatArmour.slots)
    boxes = slots.inject({:even => [], :odd => []}) do |out, stat|
      name = "armour_slot[#{stat.last}]"
      this_box = label_tag(name, check_box_tag(name, stat.last, armour_stat.include?(stat.last)) << '&nbsp;' << stat.first.humanize)
      if slots.index(stat).even?
        out[:even] << this_box
      else
        out[:odd] << this_box
      end
      #raise out.to_yaml
      out
    end
    content_tag(:div, :id => 'slot_boxes') do
      content_tag(:table) do
        content_tag(:tr) do
          content_tag(:td, boxes[:even].join('<br />')) + content_tag(:td, boxes[:odd].join('<br />')) 
        end
      end
    end
  end

  def armour_slot_links(armour_stat)
    armour_stat.slot_sorted_by_name_to_a.inject([]) do |links, slot|
      links << link_to(ItemStatArmour.slots[slot].humanize, item_cat_sub_path(Item::ItemCatArmour, slot))
    end.join(', ')
  end

end
