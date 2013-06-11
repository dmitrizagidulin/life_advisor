module RippleSearch
  def all
    self.list
  end
  
  def from_search_result(document)
    fields = document['fields']
    fields.delete('_type') # Remove the _type key, gives an error when instantiating
    deprecated_fields = ['project_key', 'action_item_key']
    deprecated_fields.each { |field_name| fields.delete(field_name) }
    item = self.new(fields)
    item.key = document['id']
    item
  end
  
  def search_results_for(search_string, sort_field=:created_at, rows=10000)
    search_results = Ripple.client.search self.bucket.name, search_string, sort: sort_field, rows: rows
    search_results['response']['docs']
  end
end