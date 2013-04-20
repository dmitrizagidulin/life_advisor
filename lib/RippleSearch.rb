module RippleSearch
  def all
    self.list
  end
  
  def from_search_result(document)
    fields = document['fields']
    fields.delete('_type') # Remove the _type key, gives an error when instantiating
    action_item = self.new(fields)
    action_item.key = document['id']
    action_item
  end
  
  def search_results_for(search_string, rows=10000)
    search_results = Ripple.client.search self.bucket.name, search_string, rows: rows
    search_results['response']['docs']
  end
end