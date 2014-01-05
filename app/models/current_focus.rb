require 'RippleSearch'

class CurrentFocus
  include Ripple::Document
  extend RippleSearch
  
  property :focus_type, String
  property :focus_key, String
  timestamps!
  
  def load_instance
    klass = self.focus_type.constantize
    instance = klass.new
    instance.key = self.focus_key
    instance.reload
    instance
  end
  
  def self.on(item)
    focus = CurrentFocus.new
    focus.key = Elefsis::DEFAULT_FOCUS_KEY
    focus.focus_type = item.class.to_s
    focus.focus_key = item.key
    focus
  end
  
  def self.today
    focus = CurrentFocus.new
    focus.key = Elefsis::DEFAULT_FOCUS_KEY
    focus.focus_type = 'DayLog'
    focus.focus_key = :today
    focus
  end
end