module GeneralMixinHelpers

  protected

  def admin_or_moderator?
    result = logged_in? && (admin? || moderator?)
    if block_given?
      if result
        yield
      else
        render :partial => 'shared/not_authorised', :layout => true
      end  
    end
    result
  end
  

end