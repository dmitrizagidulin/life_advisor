require 'RippleSearch'

class Elefsis
  include Ripple::Document
  extend RippleSearch
  
  DEFAULT_FOCUS_KEY = '_current_focus'
  
  def self.current_focus
    focus = CurrentFocus.find(Elefsis::DEFAULT_FOCUS_KEY)
    if focus.focus_type == 'DayLog' && focus.focus_key.to_sym == :today
      DayLog.today
    else
      focus.load_instance
    end
  end
  
  def self.focus_on(item)
    focus = CurrentFocus.on item
    focus.save!
  end
  
  def self.reset_focus!
    focus = CurrentFocus.today
    focus.save!
  end
  
  def self.today
    DayLog.today
  end
end