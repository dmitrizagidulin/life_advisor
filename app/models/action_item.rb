class ActionItem
  include Ripple::Document
  
  property :name, String
  timestamps!
  
  def self.all
    ActionItem.list
  end
end
