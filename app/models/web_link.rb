require 'RippleSearch'

class WebLink
  include Ripple::Document
  extend RippleSearch
  
  property :name, String
  property :url, String, :presence => true

  property :parent_type, String  # One of [:project]
  property :parent_key, String  # (Optional) An action item can belong to a Project, or another action item, etc

  
  timestamps!
  
  def self.for_parent(parent_type, parent_key)
    search_string = "parent_type:#{parent_type} AND parent_key:#{parent_key}"
    results = self.search_results_for(search_string, sort_field='created_at desc')
    results.collect { |doc| WebLink.from_search_result(doc) }
  end

  def from_search_result(document)
    item = super.from_search_result(document)
    item
  end
end
