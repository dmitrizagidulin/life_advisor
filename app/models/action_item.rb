require 'RippleSearch'

class ActionItem
  include Ripple::Document
  include Comparable
  extend RippleSearch

  property :name, String, :presence => true
  property :done, Boolean, :default => false
  property :mywn_category, String, :default => :someday # One of [:critical, :opportunity, :horizon, :someday, :tomorrow]
  property :completed_at, Time
  property :description, String
  property :area, String, :default => :admin # Realms/Areas of concern. One of [:soul, :work, :admin, :assistant ]
  property :parent_type, String  # One of [:project]
  property :parent_key, String  # (Optional) An action item can belong to a Project, or another action item, etc
  
  timestamps!
  
  # TODO: Unit test
  def <=>(anOther)
    # First, sort on Done status
    return -1 if self.done and not anOther.done
    return 1 if not self.done and anOther.done
    
    # In case both are done, sort on Completed At time
    if self.done and anOther.done
      return self.completed_at <=> anOther.completed_at unless self.completed_at.nil? or anOther.completed_at.nil?
    end
    
    # Next, sort on MYWN Category
    unless self.mywn_category.nil? or anOther.mywn_category.nil?
      category_cmp = self.mywn_category_order <=> anOther.mywn_category_order
      return category_cmp unless category_cmp == 0
    end

    # Next, sort on Focus Area
    unless self.area.nil? or anOther.area.nil?
      area_cmp = self.area_order <=> anOther.area_order
      return area_cmp unless area_cmp == 0
    end
    
    # Lastly, sort on Created At time
    self.created_at <=> anOther.created_at
  end
  
  def area_order
    ActionItem.areas.find_index self.area.to_s
  end
  
  def has_parent?
    not self.parent_type.nil? and not self.parent_type.empty?
  end
  
  def parent
    if self.parent_type.to_sym == :project
      parent = Project.find(self.parent_key)
    end
    parent
  end
  
  def parent_url
    if self.parent_type.to_sym == :project
      return "/projects/#{self.parent_key}"
    end
  end
  
  def mywn_category_order
    ActionItem.mywn_categories.find_index self.mywn_category
  end
  
  def toggle_done!
    self.done = !self.done
    if self.done
      self.completed_at = Time.zone.now
    else
      self.completed_at = nil
    end
    self.save
  end
  
  def self.all_todo(mywn_category=nil, focus_area=nil, include_projects=true)
    if mywn_category
      search_string = "done:false AND mywn_category:"+mywn_category.to_s
    else
      search_string = "done:false"
    end
    
    if not focus_area.nil? and focus_area.to_sym == :admin
      search_string += " AND (area:admin OR area:assistant)"
    elsif not focus_area.nil?
      search_string += " AND area:#{focus_area}"
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
  
  def self.areas
    ['soul', 'work', 'admin', 'assistant']
  end
  
  # TODO: Unit test
  def self.is_valid_category?(category)
    ActionItem.mywn_categories.include? category.to_s
  end
  
  # TODO: Unit test
  def self.mywn_category_move(category_from, category_to)
    unless ActionItem.is_valid_category? category_from
      raise ArgumentError, "Invalid MYWN Category"
    end
    unless ActionItem.is_valid_category? category_to
      raise ArgumentError, "Invalid MYWN Category"
    end
    category_items = ActionItem.all_todo(category_from)
    category_items.each do | item |
      item.mywn_category = category_to
      item.save!
    end
    category_items.count  # Return the number of items moved
  end
  
#  def from_search_result(document)
#    action_item = super.from_search_result(document)
#    action_item.done = action_item.done == 'true'
#    action_item
#  end
end
