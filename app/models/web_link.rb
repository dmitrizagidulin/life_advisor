require 'RippleSearch'
require 'Parentable'

class WebLink
  include Ripple::Document
  extend RippleSearch
  include Parentable
  
  property :name, String
  property :url, String, :presence => true
  timestamps!
  
  before_create :enforce_default_day_parent
  before_update :enforce_default_day_parent

  def name_display
    if self.name.empty? and not self.url.empty?
      return self.url.truncate(50)
    end
    self.name
  end
  
end
