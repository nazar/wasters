class ItemsController < ApplicationBaseController

  helper :quests
  include ItemMixinHelpers

  before_filter :login_required, :except => [:index, :filter, :show, :by_categories]
  before_filter :admin_or_moderator_required, :only => [:destroy]

#  if AppConfig.allow_anonymous_commenting
#    skip_before_filter :verify_authenticity_token, :only => [:create]
#    skip_before_filter :login_required, :only => [:create]
#  end

  uses_tiny_mce(:only => [:new, :edit, :create, :update, :show]) do
    AppConfig.simple_mce_options
  end

  def index
    @page_title = :item_db.l
    @items = Item.ascend_by_title.paginate :page => params[:page]
  end

  def filter
    letter = params[:letter]
    @page_title = "#{:item_db.l} - Filtered by #{letter}"
    @items = Item.letter_filter(letter).ascend_by_title.paginate :page => params[:page]
    #
    render :action => :index
  end

  def new
    @item = Item.new
    @schematics = {}
  end

  def create
    cleanup_params
    @item = Item.new(params[:item])
    @item.user_id = current_user.id
    Item.transaction do
      if save_or_update_item(@item)
        redirect_to items_path
      else
        new_item_links_from_params
        render :action => :new
      end
    end
  end

  def edit
    @item = Item.find(params[:id])
    can_edit(@item) do
      @recipe_item_links = @item.item_links.recipes.item_ordered
      @schematics = @item.full_schematics_hash[:assembley]
      @stat       = @item.stats
      @page_title = "#{@item.title} - Editing Item"
    end
  end

  def update
    cleanup_params
    @item = Item.find(params[:id])
    can_edit(@item) do
      @item.attributes = params[:item]
      @item.updated_by = current_user.id
      Item.transaction do
        if save_or_update_item(@item)
          @item.create_action_user_activity('updated', current_user) unless Activity.last.item_id == @item.id
          redirect_to item_path(@item)
        else
          new_item_links_from_params
          render :action => :new
        end
      end
    end  
  end

  def show
    @item = Item.find(params[:id])
    @item.hit!(true)
    #
    @schematics  = @item.full_schematics_hash
    @quests      = @item.item_quests
    @monsters    = @item.monsters
    @merchants   = @item.merchants
    @nodes       = @item.nodes
    @mines       = @item.mines
    #
    @component_for_items = @item.component_for_items.paginate :per_page => 50, :page => params[:items_page]
    #
    @item_links   = @item.item_links.recipes.by_level_and_name :include => :link
    #
    @page_title = "#{@item.title} - Fallen Earth Items Database"
  end

  def by_categories
    @cat = params[:cat].to_i; @sub = params[:sub]; @type = params[:type].to_i
    @items = Item.ascend_by_title.by_type_and_sub(@cat, @sub, :includes => true).paginate :page => params[:page]
    #
    filters = [Item.categories[@cat].humanize]
    filters << Item.item_cat_sub_type(@cat, @sub).humanize unless @sub.blank?
    @filter = " #{filters.join(' and ')}" #TODO filter to contain cat and sub links
    #
    @page_title = "Items filtered by #{@filter}- Fallen Earth Items Database"
  end

  def schematic
    respond_to do |format|
      format.js {render :partial => 'items/form_schematic', :locals => {:schematic => {:qty => 1 },
                                                                        :schematic_id =>  rand(10000)*-1 }}
      format.html {render :text => 'Javascript support required'}
    end
  end

  #called by JS when adding an item_link
  def item_links
    @item_link = ItemLink.new(:qty => 1, :link_type => 'Item')
    @item_link.id = rand(10000) * -1
    respond_to do |format|
      format.html {render :text => 'Javascript support required'}
      format.js   {render :partial => 'item_links/edit_verb', :locals => {:item_link => @item_link, :verb => 'recipe'} }
    end
  end

  def properties
    @item = Item.find_or_initialize_by_id(params[:lookup_id])
    @item.category = params[:select_id]
    @stat = @item.stats
    respond_to do |format|
      format.js  {render :action => :properties, :layout => false}
      format.html {render :text => 'Javascript support required'}
    end
  end

  def get_for_ajax
    if params[:mask] && params[:mask].length > 2
      @items = Item.name_search(params[:mask]).ascend_by_title
    else
      @items = []
    end
    #
    respond_to do |format|
      format.xml {}
    end
  end

  def weapon_sub
    type = params[:id].to_i
    respond_to do |format|
      format.js{render :partial => 'item_stat_weapons/weapon_sub_select', :locals => {:weapon_type => type}}
      format.html{render :text => 'Javascript support required'}
    end
  end

  protected

  def save_or_update_item(item)
    if item.save
      item.save_skills(params[:item_skills]) unless params[:item_skills].blank?
      item.save_damages(params[:item_damage]) unless params[:item_damage].blank?
      item.save_recipes(params[:recipe]) unless params[:recipe].blank?
      item.save_armour_slots(params[:armour_slot]) unless params[:armour_slot].blank?

      item.save_schematics(params[:assembley], current_user.id) unless params[:assembley].blank?

      item.save
      true
    else
      false
    end
  end

  def cleanup_params
    if params[:item][:item_stat_weapon_attributes] && params[:item][:item_stat_weapon_attributes].delete(:ammo_item_id_new_value) == 'true'
      params[:item][:item_stat_weapon_attributes].delete(:ammo_item_id)
    end
  end

  def new_item_links_from_params
    def post_hash_to_item_links(in_params, link_type)
      ItemLink.item_links_from_hash(in_params, link_type, true).inject([]) do |objs, item_link_hash|
        item_link = ItemLink.new(item_link_hash)
        item_link.id = item_link_hash[:id]
        objs << item_link
      end
    end
    ###############################
    @stat       = @item.stats
    @schematics = params[:assembley] || {}
    if @item.category == Item::ItemCatManualCraft
      @recipe_item_links = post_hash_to_item_links(params[:recipe], ItemLink::LinkTypeRecipe)
    end  
  end

  #only item user or admin or moderator can edit this item
  def can_edit(item)
    if item.owner?(current_user) || admin_or_moderator?
      yield
    else
      render :partial => 'items/cannot_edit', :layout => true
    end
  end


end
