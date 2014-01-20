class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_focus_exists?, :current_focus
  
  def current_focus
#    @current_focus ||= Elefsis.current_focus
    Elefsis.current_focus
  end
  
  def current_focus_exists?
    current_focus != Elefsis.today
  end
end
