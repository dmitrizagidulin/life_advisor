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
