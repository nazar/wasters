ActionController::Routing::Routes.draw do |map|
  #quests
  map.resources :quests, :collection => {:lookup => :get, :filter_lookup => :get}
  map.recent_quests      'quests/recent',              :controller => 'quests', :action => 'recent'
  map.all_quests         'quests/all',                 :controller => 'quests', :action => 'all'
  map.user_quest         'quests/show/:user/:id',      :controller => 'quests', :action => 'show'
  map.quest_item         'quests/items/get',           :controller => 'quests', :action => 'get_items'
  map.quest_sector       'quests/by/sector/:sector',   :controller => 'quests', :action => 'by_sector'
  map.quest_faction      'quests/by/faction/:faction', :controller => 'quests', :action => 'by_faction'
  map.quest_filter       'quests/filter/:letter',      :controller => 'quests', :action => 'filter'       

  #items db
  map.resources :items
  map.recent_quests      'items/recent',           :controller => 'items', :action => 'recent'
  map.all_items          'items/all',              :controller => 'items', :action => 'all'
  map.item_schematics    'items/schematic/get',    :controller => 'items', :action => 'schematic'
  map.item_links         'items/links/get/:verb',  :controller => 'items', :action => 'item_links'         
  map.user_item          'items/show/:user/:id',   :controller => 'items', :action => 'show'
  map.item_filter        'items/filter/:letter',   :controller => 'items', :action => 'filter'         
  map.get_item_stats     'items/properties/get',   :controller => 'items', :action => 'properties'
  map.items_ajax         'items/ajax/get',         :controller => 'items', :action => 'get_for_ajax'
  map.get_item_wep_subs  'items/weapon_sub/:id',   :controller => 'items', :action => 'weapon_sub'
  map.item_cat           'items/by/cat/:cat',      :controller => 'items', :action => 'by_categories'
  map.item_cat_sub       'items/by/cat/:cat/:sub', :controller => 'items', :action => 'by_categories'
  map.item_cat_sub_type  'items/by/cat/:cat/:sub/:type', :controller => 'items', :action => 'by_categories'

  #mobs
  map.resources :mobs
  map.all_mobs           'mobs/all/mobs',           :controller => 'mobs', :action => 'all'
  map.items_mobs         'mobs/items/get/:verb',    :controller => 'mobs', :action => 'items'
  map.mob_properties     'mobs/properties/get',     :controller => 'mobs', :action => 'properties'
  map.user_mob           'mobs/show/:user/:id',     :controller => 'mobs', :action => 'show'
  map.mob_cat            'mobs/by/cat/:cat',        :controller => 'mobs', :action => 'by_categories'
  map.mob_difficulty     'mobs/by/difficult/:diff', :controller => 'mobs', :action => 'by_difficulty'
  map.mob_filter         'mobs/filter/:letter',     :controller => 'mobs', :action => 'filter'
  map.questors_ajax      'mobs/list/get/:type',     :controller => 'mobs', :action => 'get_for_xml'

  #search
  map.search             'search',                  :controller => 'search', :action => 'index' 

  #community engine routes
  map.routes_from_plugin :community_engine



  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
