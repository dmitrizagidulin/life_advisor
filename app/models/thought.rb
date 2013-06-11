require 'RippleSearch'

class Thought
  include Ripple::Document
  include Ripple::Callbacks
  extend RippleSearch
  
  property :name, String, :presence => true
  property :parent_type, String  # One of [:project, :day]
  property :parent_key, String  # (Optional) An action item can belong to a Project, or a day

  timestamps!

  before_create :action_before_create
  
  def action_before_create
    if not self.parent_type or (self.parent_type == 'day' and self.parent_key == 'today')
      self.parent_type = 'day'
      self.parent_key = Time.now.localtime.strftime('%Y-%m-%d')
    end
  end
  
  def self.for_parent(parent_type, parent_key)
    search_string = "parent_type:#{parent_type} AND parent_key:#{parent_key}"
    results = self.search_results_for(search_string, sort_field='created_at desc')
    results.collect { |doc| Thought.from_search_result(doc) }
  end

  def from_search_result(document)
    super.from_search_result(document)
  end
end
