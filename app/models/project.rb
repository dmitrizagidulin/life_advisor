class Project
  include Ripple::Document
  
  property :name, String, :presence => true
  property :description, String
  timestamps!
  
  
end
