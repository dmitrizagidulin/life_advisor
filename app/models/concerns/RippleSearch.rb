module RippleSearch
  def all
    self.list
  end
  
  def from_search_result(document)
    fields = document.keys
    document.delete('_type') # Remove the _type key, gives an error when instantiating
    deprecated_fields = ['project_key', 'action_item_key']
    deprecated_fields.each { |field_name| document.delete(field_name) }
    key = document['id']
    document.delete('id')
    item = self.new(document)
    item.persist!
    item.key = key
    item
  end
  
  def search_results_for(search_string, sort_field=:created_at, rows=10000)
#    puts "Searching #{self.bucket.name}:#{search_string}"
    search_results = Ripple.client.search self.bucket.name, search_string, sort: sort_field, rows: rows
#    search_results['response']['docs']
    search_results['docs']
  end
end