require 'RippleSearch'
require 'Parentable'

class ActionItem
  include Ripple::Document
  include Comparable
  extend RippleSearch
  include Parentable

  property :name, String, :presence => true
  property :done, Boolean, :default => false
  property :mywn_category, String, :default => :someday # One of [:critical, :opportunity, :horizon, :someday, :tomorrow]
  property :completed_at, Time
  property :description, String
  property :area, String, :default => :admin # Realms/Areas of concern. One of [:soul, :work, :admin, :assistant ]
  property :time_elapsed, Float, :default => 0  # Elapsed time, in hours. E.g.: 1.5
  property :bump_count, Integer, default: 0  # Number of times I've thought about the task
  
  timestamps!
  
  before_update :enforce_completed_at
  
  def <=>(anOther)
    # Sort on Bump Count first, descending
    bump_cmp = anOther.bump_count <=> self.bump_count
    return bump_cmp unless bump_cmp == 0
    
    # Next, sort on Focus Area (in the order of self.areas() array)
    unless self.area.nil? or anOther.area.nil?
      area_cmp = self.area_order <=> anOther.area_order
      return area_cmp unless area_cmp == 0
    end
    
    # Lastly, sort on Created At time, desc
    anOther.created_at <=> self.created_at 
  end
  
  def oldCompare(anOther)
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

    # Next, sort on Focus Area (in the order of self.areas() array)
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
  
  def bump
    self.bump_count += 1
  end
  
  def bump!
    self.bump
    self.save
  end
  
  def completed_same_day?
    unless self.completed_at
      return false
    end
    self.created_at.to_date === self.completed_at.to_date
  end
  
  def day_sort_key
    if self.done and self.completed_at.present?
      return self.completed_at
    else
      return self.created_at
    end
  end
  
  def enforce_completed_at
    if self.done and self.completed_at.nil?
      self.completed_at = Time.zone.now
    end
  end
  
  def links
    @links ||= WebLink.for_parent(:action_item, self.key)
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
  
  def self.mywn_categories
    ['critical', 'tomorrow', 'opportunity', 'horizon', 'someday']
  end
  
  def self.areas
    ['work', 'soul', 'admin', 'assistant']
  end
  
  def self.hash_by_date(items)
    created_items = {}
    completed_items = {}
    items.each do | item |
      if item.completed_at
        completed_key = item.completed_at.localtime.to_date
        if completed_items.include? completed_key
          completed_items[completed_key].append(item)
        else
          completed_items[completed_key] = [item]
        end
      end
      created_key = item.created_at.localtime.to_date
      if created_items.include? created_key
        created_items[created_key].append(item)
      else
        created_items[created_key] = [item]
      end
    end
    return created_items, completed_items
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
