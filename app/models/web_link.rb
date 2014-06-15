require 'RippleSearch'
require 'Parentable'

class WebLink
  include Ripple::Document
  extend RippleSearch
  include Parentable
  
  property :name, String
  property :url, String, :presence => true
  property :description, String
  timestamps!
  
  before_create :enforce_default_day_parent
  before_update :enforce_default_day_parent

  def name_display
    if self.name.blank? and self.url.present?
      return self.url.truncate(50)
    end
    self.name
  end
  
  # Initialize a new WebLink from an ActionItem instance
  def self.from_action_item(action_item)
    link = WebLink.new name: action_item.name
    link.url = action_item.links.first.url
    link.parent_type = action_item.parent_type
    link.parent_key = action_item.parent_key
    link
  end
end
