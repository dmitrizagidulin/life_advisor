class ActionItem
  include Ripple::Document
  
  property :name, String, :presence => true
  property :done, Boolean, :default => false
  
  timestamps!
  
  def toggle_done!
    self.done = !self.done
    self.save
  end
  
  def self.all
    ActionItem.list
  end
  
  def self.all_todo
    results = self.search_results_for("done:false")
    results.collect { |doc| ActionItem.from_search_result(doc) }
  end
  
  def self.all_completed
    results = self.search_results_for("done:true")
    results.collect { |doc| ActionItem.from_search_result(doc) }
  end
  
  def self.from_search_result(document)
    fields = document['fields']
    fields.delete('_type') # Remove the _type key, gives an error when instantiating ActionItem
    fields['done'] = fields['done'] == 'true'
    action_item = ActionItem.new(fields)
    action_item.key = document['id']
    action_item
  end
  
  def self.search_results_for(search_string)
    search_results = Ripple.client.search ActionItem.bucket.name, search_string
    search_results['response']['docs']
  end
end
