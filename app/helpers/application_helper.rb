# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  include ItemMixinHelpers
  include GeneralMixinHelpers

  def show_app_footer_content?
    current_page?(:controller => 'quests', :action => 'index') ||
    current_page?(:controller => 'mobs', :action => 'index') ||
    ((controller_name == 'items') && ['index', 'by_categories'].include?(action_name)) ||
    show_footer_content? # <-- defined in engine
  end

  def jquery_include_tag(*libs)
    js_libs = []
    js_opts = {}
    libs.each do |library|
      case
        when library.is_a?(String)
          js_libs << "jquery/#{library}"
        when library.is_a?(Hash)
          js_opts.merge!(library)
      end
    end
    javascript_include_tag js_libs, js_opts
  end

  def stat_line(label, content)
    content_tag(:li) do
      content_tag(:label, label)  <<
      content_tag(:span, content, :class => 'content')                                             
    end unless content.blank?
  end

  def order_key_value_hash(hash)
    hash.sort{|a,b|a[1]<=>b[1]}.collect{|h|[h.last, h.first]}
  end

  def main_div_class
    if ((controller_name == 'items') && (['index', 'filter', 'by_categories'].include?(action_name))) ||
       ((controller_name == 'mobs') && (['index', 'filter', 'by_categories', 'by_difficulty'].include?(action_name))) ||
       ((controller_name == 'quests') && (['index', 'filter', 'by_sector', 'by_faction'].include?(action_name)))         
      "yui-t4"
    else
      "yui-t#{@sidebar_left ? 3 : 6}"
    end
  end

  def my_will_paginate(paginator, options = {}, html_options = {})
    if paginator.total_entries > 0
      links = will_paginate paginator, html_options.merge(:class => nil)
      if options[:show_info].eql?(false)
        content_tag(:div, (links || ''), :class => 'pagination') unless links.blank?
      else
        content_tag(:div, :class => 'pagination') do
          content_tag(:div, pagination_info_for(paginator), :class => 'pagination_info') << (links || '')
        end
      end
    end  
  end

  def alphabet_filter(collection)
    raise "block must be supplied" unless block_given?
    s_letters = 'A'..'Z'
    #
    table = content_tag(:table, :class => 'alphabet_filter', :cellpadding => 0, :cellspacing => 0) do
      content_tag(:tr) do
        s_letters.inject('') do |output, letter|
          output << content_tag(:td) do
            unless collection[letter].nil?
              yield(letter, collection[letter]).to_s
            else
             content_tag(:span, letter, :class => 'empty')
            end
          end
        end
      end
    end
    concat(table)
  end

  def items_ajax_box(name, value, value_text, options={})
    #sanitise_name
    options.reverse_merge!(:id => name.gsub('[','_').gsub(']','') )
    options.reverse_merge!(:class => 'class="item_ajax_combo"')
    options.reverse_merge!(:style => '')
    options.reverse_merge!(:path => items_ajax_path)
    options.reverse_merge!(:width => 200)
    #
    render :partial => 'shared/ajax_select', :locals => {:name => name, :value => value, :value_text => value_text, 
                                                              :option_id => options[:id], :ajaxed => true,
                                                              :option_path => options[:path],
                                                              :option_width => options[:width],
                                                              :option_class => options[:class],
                                                              :option_style => options[:style]}
  end

  def item_icons(item)
    icons = []
    icons << link_to(image_tag('edit.png', :title => 'Edit item'), edit_item_path(item))
    icons << image_tag('bubble2.png', :title => pluralize(item.comments_count, 'comment')) if item.comments_count.to_i > 0
    icons << image_tag('noicon.png', :title => 'Item has no icon') if item.icon_file_name.blank?
    icons << image_tag('norecipe.png', :title => 'Item has no recipe') unless item.has_schematic
    icons.join('')
  end
  



end
