module QuestsHelper

  def quest_sector_select
    select :quest, :sector, order_key_value_hash(Quest.sectors)
  end

  def faction_type_select
    select :quest, :faction_type, order_key_value_hash(Quest.faction_types), { :include_blank => true }
  end

  def quest_giver_select(value, value_text, options={})
    #sanitise_name
    options.reverse_merge!(:name => 'quest[quest_giver_id]' )
    options.reverse_merge!(:id => options[:name].gsub('[','_').gsub(']','') )
    options.reverse_merge!(:class => 'class="quest_ajax_combo"')
    options.reverse_merge!(:style => '')
    options.reverse_merge!(:path => questors_ajax_path(Mob::MobQuestorsType))
    options.reverse_merge!(:width => 200)
    #
    render :partial => 'shared/ajax_select', :locals => {:name => options[:name], :value => value, :value_text => value_text,
                                                         :option_id => options[:id], :ajaxed => false,
                                                         :option_path => options[:path],
                                                         :option_width => options[:width],
                                                         :option_class => options[:class],
                                                         :option_style => options[:style]}
  end

  #builds previous quest select
  def previous_quest_select(quest, quests)
    select_tag :previous_quest, 
               options_for_select(quests.collect{|q|[q.title, q.id.to_s]}.insert(0, ''),
                                  :selected => quest.previous_quest.blank? ? 0 : quest.previous_quest.id.to_s),
             {:style => 'width: 300px;'}
  end

  def quest_chain_link(view_quest, chain_quest)
    if view_quest.id == chain_quest.id
      content_tag(:li, content_tag(:strong, h(chain_quest.title)))
    else
      content_tag(:li, link_to(h(chain_quest.title), quest_path(chain_quest)))
    end
  end
  
  def zone_list(zone = 0)
    content_tag(:ul) do
      order_key_value_hash(Quest.sectors).inject('') do |out, sector|
        if zone == sector.last
          out << content_tag(:li, content_tag(:strong, sector.first))
        else
          out << content_tag(:li, link_to(sector.first, quest_sector_path(sector.last)))
        end
      end
    end
  end

  def faction_list(faction = 0)
    content_tag(:ul) do
      order_key_value_hash(Quest.faction_types).inject('') do |out, a_faction|
        if faction == a_faction.last
          out << content_tag(:li, content_tag(:strong, a_faction.first.humanize))
        else
          out << content_tag(:li, link_to(a_faction.first.humanize, quest_faction_path(a_faction.last)))
        end
      end
    end
  end

  def quest_giver_name_link(quest)
    unless quest.quest_giver_name.blank?
      link_to quest.quest_giver_name, mob_path(quest.quest_giver_id)
    end
  end



end
