require 'RippleSearch'

class ProjectGoal
  include Ripple::Document
  extend RippleSearch
  
  property :project_key, String, :presence => true
  property :goal_key, String, :presence => true
  timestamps!
  
  
end
