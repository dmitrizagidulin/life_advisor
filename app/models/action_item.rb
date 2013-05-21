require 'RippleSearch'

class ActionItem
  include Ripple::Document
  extend RippleSearch

  property :name, String, :presence => true
  property :done, Boolean, :default => false
  property :mywn_category, String, :default => :someday # One of [:critical, :opportunity, :horizon, :someday, :tomorrow]
  property :completed_at, Time
  property :parent_type, String  # One of [:project]
  property :parent_key, String  # (Optional) An action item can belong to a Project, or another action item, etc
  
  timestamps!
  
  def toggle_done!
    self.done = !self.done
    if self.done
      self.completed_at = Time.zone.now
    else
      self.completed_at = nil
    end
    self.save
  end
  
  def self.all_todo(mywn_category=nil, include_projects=true)
    if mywn_category
      search_string = "done:false AND mywn_category:"+mywn_category.to_s
    else
      search_string = "done:false"
      
    end
    results = self.search_results_for(search_string)
    results = results.collect { |doc| ActionItem.from_search_result(doc) }
    unless include_projects
      results = results.select { | item | item.parent_key.nil? or item.parent_key.empty? }
    end
    results
  end
  
  def self.all_completed
    results = self.search_results_for("done:true")
    results.collect { |doc| ActionItem.from_search_result(doc) }
  end
  
  def self.for_parent(parent_type, parent_key)
    search_string = "parent_type:#{parent_type} AND parent_key:#{parent_key}"
    results = self.search_results_for(search_string)
    results.collect { |doc| ActionItem.from_search_result(doc) }
  end
  
  def self.mywn_categories
    ['critical', 'tomorrow', 'opportunity', 'horizon', 'someday']
  end
  
#  def from_search_result(document)
#    action_item = super.from_search_result(document)
#    action_item.done = action_item.done == 'true'
#    action_item
#  end
end
