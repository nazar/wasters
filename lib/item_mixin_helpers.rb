#for use by Controllers and Views where methods are required by both
module ItemMixinHelpers

  def items_select_hash
    Item.ascend_by_title.collect{|i|[i.title.capitalize, i.id]}.insert(0,'')
  end

  def mob_items_param_items(params)
    params[params.keys.first] unless params.nil?
  end
  
end