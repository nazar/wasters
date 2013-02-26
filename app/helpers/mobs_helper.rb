module MobsHelper

  def mob_types_for_select
    order_key_value_hash(Mob.mob_types)
  end

  def render_mob_properties_by_type(mob_type)
    case mob_type
      when Mob::MobTypeMob
        render :partial => 'mobs/form_mob'
      when Mob::MobTypeMerchant
        render :partial => 'mobs/form_merchant'
      when Mob::MobTypeNode
        render :partial => 'mobs/form_node'
      when Mob::MobTypeMine
        render :partial => 'mobs/form_mine'
    end
  end

  def mob_difficulties_for_select
    Mob.mob_difficulties.sort{|a,b|a[0]<=>b[0]}.collect{|i|["#{i.first} - #{i.last}", i.first]}
  end

  def mob_mob_properties(mob)
    header = content_tag(:h3, mob.mob_item_type_to_s.humanize << ' Properties')
    list = render :partial => 'mobs/properties', :locals => {:mob => mob}
    header << list
  end

  def mob_type_links(category = 0)
    list = order_key_value_hash(Mob.mob_types).inject('') do |out, mob_type|
      if mob_type.last == category
        out << content_tag(:li, content_tag(:strong, mob_type.first.humanize))
      else
        out << content_tag(:li, link_to(mob_type.first.humanize, mob_cat_path(mob_type.last)))
      end
    end
    content_tag(:ul, list)
  end

  def mob_difficulty_links(difficulty = 0)
    list = Mob.mob_difficulties.sort{|a,b|a[0]<=>b[0]}.inject('') do |out, mob_diff|
      if mob_diff.first == difficulty
        out << content_tag(:li, content_tag(:strong, mob_diff.last.humanize))
      else
        out << content_tag(:li, link_to(mob_diff.last.humanize, mob_difficulty_path(mob_diff.first)))
      end
    end
    content_tag(:ul, list)
  end

  def mob_properties(mob)
    result = ''
    if mob.coords_x || mob.coords_y
      content_tag(:h3, 'Coordinates') <<
      content_tag(:ul, :class => 'properties_list') do
        result << stat_line(:coords_x.l, mob.coords_x.to_s) unless mob.coords_x.blank?
        result << stat_line(:coords_y.l, mob.coords_y.to_s) unless mob.coords_y.blank?
        result
      end
    end
  end

  def list_quests(quests)
    content_tag(:ul, :class => 'properties_list') do
      quests.inject('') do |output, quest|
        output << content_tag(:li, link_to(h(quest.title), quest_path(quest.id)))
      end
    end
  end


end
