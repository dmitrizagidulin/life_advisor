module RippleSearch
  def all
    ActionItem.list
  end
  
  def from_search_result(document)
    fields = document['fields']
    fields.delete('_type') # Remove the _type key, gives an error when instantiating ActionItem
    fields['done'] = fields['done'] == 'true'
    action_item = ActionItem.new(fields)
    action_item.key = document['id']
    action_item
  end
  
  def search_results_for(search_string)
    search_results = Ripple.client.search ActionItem.bucket.name, search_string
    search_results['response']['docs']
  end
end