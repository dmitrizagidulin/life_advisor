require 'RippleSearch'

class Project
  include Ripple::Document
  extend RippleSearch
  
  property :name, String, :presence => true
  property :description, String
  property :status, String, :default => :idea  # One of [:idea, :active, :someday, :canceled, :completed]
  
  timestamps!
  
  def self.all_for_status(status)
    search_string = "status:"+status.to_s
    results = self.search_results_for(search_string)
    results.collect { |doc| self.from_search_result(doc) }
  end
end
