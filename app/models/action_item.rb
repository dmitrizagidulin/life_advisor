class ActionItem
  include Ripple::Document
  
  property :name, String, :presence => true
  property :done, Boolean, :default => false
  
  timestamps!
  
  def self.all
    ActionItem.list
  end
end
