require 'RippleSearch'

class WebLink
  include Ripple::Document
  extend RippleSearch
  
  property :name, String
  property :url, String, :presence => true

  property :action_item_key, String  # (Optional) A link can belong to an ActionItem
  property :project_key, String  # (Optional) A link can belong to a Project
  
  timestamps!
  
  def self.for_project(project_key)
    search_string = "project_key:#{project_key}"
    results = self.search_results_for(search_string)
    results.collect { |doc| WebLink.from_search_result(doc) }
  end

  def from_search_result(document)
    item = super.from_search_result(document)
    item
  end
end
