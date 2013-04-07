require 'RippleSearch'

class Project
  include Ripple::Document
  extend RippleSearch
  
  property :name, String, :presence => true
  property :description, String
  property :status, String, :default => :idea  # One of [:idea, :active, :someday, :cancelled, :completed]
  
  timestamps!
  
  
end
