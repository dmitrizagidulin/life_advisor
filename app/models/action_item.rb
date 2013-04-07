require 'RippleSearch'

class ActionItem
  include Ripple::Document
  extend RippleSearch

  property :name, String, :presence => true
  property :done, Boolean, :default => false
  property :mywn_category, String, :default => :someday
  
  timestamps!
  
  def toggle_done!
    self.done = !self.done
    self.save
  end
  
  def self.all_todo(mywn_category=nil)
    if mywn_category
      search_string = "done:false AND mywn_category:"+mywn_category
    else
      search_string = "done:false"
      
    end
    results = self.search_results_for(search_string)
    results.collect { |doc| ActionItem.from_search_result(doc) }
  end
  
  def self.all_completed
    results = self.search_results_for("done:true")
    results.collect { |doc| ActionItem.from_search_result(doc) }
  end
  
  def from_search_result(document)
    action_item = super.from_search_result(document)
    action_item.done = action_item.done == 'true'
    action_item
  end
end
