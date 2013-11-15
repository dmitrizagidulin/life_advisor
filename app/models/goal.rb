require 'RippleSearch'
require 'Parentable'

class Goal
  include Ripple::Document
  extend RippleSearch
  include Parentable
  
  property :name, String
  property :description, String
  property :active, Boolean, :default => true
  property :accomplished, Boolean, :default => false
  timestamps!
  
  def project_goals
    search_string = "goal_key:#{self.key}"
    project_goal_docs = ProjectGoal.search_results_for(search_string)
  end
  
  # Keys of projects serving this goal
  def project_ids
    project_goal_docs = self.project_goals
    project_ids = project_goal_docs.collect {|pg| pg['project_key'] }
  end
  
  def projects
    Project.find(self.project_ids)
  end
  
  def sub_goals
    Goal.for_parent(:goal, self.key)
  end
  
  def self.active_goals(include_accomplished=false)
    search_string = 'active:true'
    results = Goal.search_results_for(search_string)
    results = results.collect { |doc| Goal.from_search_result(doc) }
    unless include_accomplished
      results = results.reject { | g | g.accomplished }  # filter out accomplished goals
    end
    results
  end
end
