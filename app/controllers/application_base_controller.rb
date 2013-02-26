class ApplicationBaseController < BaseController

  include GeneralMixinHelpers

  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password


  #general methods



end