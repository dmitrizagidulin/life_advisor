require 'RippleSearch'

class Elefsis
  include Ripple::Document
  extend RippleSearch
  
  def self.current_focus
    @current_focus ||= self.today
  end

  def self.current_focus=(focus)
    @current_focus = focus
  end
  
  def self.reset_focus
    self.current_focus = self.today
  end
  
  def self.today
    DayLog.today
  end
end