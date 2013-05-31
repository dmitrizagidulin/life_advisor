require 'RippleSearch'

class Project
  include Ripple::Document
  extend RippleSearch
  
  property :name, String, :presence => true
  property :description, String
  property :status, String, :default => :idea  # One of [:idea, :active, :someday, :canceled, :completed]
  property :completed_at, Time
  property :canceled_at, Time
  property :area, String, :default => :admin # Realms/Areas of concern. One of [:soul, :work, :admin, :assistant ]
  
  timestamps!
  
  def self.all_for_status(status)
    search_string = "status:"+status.to_s
    results = self.search_results_for(search_string)
    results.collect { |doc| Project.from_search_result(doc) }
  end

  def self.focus_on_area(area, status=:active)
    search_string = "status:#{status} AND area:#{area}"
    results = self.search_results_for(search_string)
    results.collect { |doc| Project.from_search_result(doc) }
  end
  
  def action_items
    ActionItem.for_parent(:project, self.key)
  end
  
  def action_items_completed
    self.action_items.select { |item| item.done }
  end

  def action_items_todo
    self.action_items.select { |item| not item.done }
  end
  
  def links
    WebLink.for_parent(:project, self.key)
  end
  
  def change_status!(new_status)
    self.status = new_status
    if new_status.to_sym == :completed
      self.completed_at = Time.now
      self.canceled_at = nil
    elsif new_status.to_sym == :canceled
      self.canceled_at = Time.now
      self.completed_at = nil
    else
      self.completed_at = nil
      self.canceled_at = nil
    end
  end
  
  def from_search_result(document)
    project = super.from_search_result(document)
    project
  end
end
