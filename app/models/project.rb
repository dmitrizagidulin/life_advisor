require 'RippleSearch'
require 'Parentable'
require 'Util'
require 'Bumpable'

class Project
  include Ripple::Document
  include Comparable
  include Parentable
  extend RippleSearch
  include Bumpable
  
  property :name, String, :presence => true
  property :description, String
  property :url, String
  property :status, String, :default => :idea  # One of [:idea, :active, :someday, :canceled, :completed]
  property :completed_at, Time
  property :canceled_at, Time
  property :area, String, :default => :admin # Realms/Areas of concern. One of [:soul, :work, :admin, :assistant ]
  property :related_projects, Set
  
  timestamps!
  
  def to_hash
    JSON.parse(self.to_json)
  end
  
  def to_hash_for_export
    proj_hash = self.to_hash
    hash_for_export = {}
    hash_for_export['key'] = self.key
    hash_for_export['name'] = self.name
    proj_hash.keys.each do | attribute |
      unless hash_for_export.include? attribute.to_s
        hash_for_export[attribute.to_s] = proj_hash[attribute]
      end
    end
    
    questions = []
    self.questions().each do | question |
      question_hash = { 'key' => question.key, 'name' => question.name || '' }
      questions.append(question_hash)
    end
    hash_for_export['questions'] = questions
    
    action_items = { 'todo' => [], 'completed' => [] }
    self.action_items.each do | item |
      if item.done
        action_items['completed'].append({ 'key'=>item.key, 'name'=>item.name})
      else
        action_items['todo'].append({ 'key'=>item.key, 'name'=>item.name})
      end
    end
    hash_for_export['action_items'] = action_items
    
    links = []
    self.links().each do | link |
      link_hash = { 'key' => link.key, 'name' => link.name || '', 'url'=> link.url }
      links.append(link_hash)
    end
    hash_for_export['links'] = links
    hash_for_export
  end
  
  def <=>(anOther)
    # First, sort in reverse bump_count order
    unless self.bump_count == anOther.bump_count 
      return anOther.bump_count <=> self.bump_count
    end
    
    # Lastly, sort alpha by name, ascending
    self.name <=> anOther.name
  end
  
  def action_items
    @action_items ||= ActionItem.for_parent(:project, self.key)
  end
  
  def action_items_completed
    self.action_items.select { |item| item.done }
  end

  def action_items_todo
    self.action_items.select { |item| not item.done }
  end
  
  def add_goal(goal_key)
    project_goal = ProjectGoal.new project_key: self.key, goal_key: goal_key
    project_goal.save
  end
  
  def add_related_project(proj_key)
    
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
  
  def current_focus!
    Elefsis.focus_on self
  end
  
  def destroy_links!
    self.links.each do | link |
      link.destroy!
    end
  end
  
  # Does this project have related projects?
  # @return [Boolean] True if this project has related projects linked to it.
  def has_related?
    self.related_projects.present?
  end
  
  def goal_ids
    goal_docs = self.project_goals
    goal_ids = goal_docs.collect {|g| g['goal_key'] }
  end
  
  def goals_served
    Goal.find(self.goal_ids)
  end
  
  def links
    WebLink.for_parent(:project, self.key)
  end
  
  def new_link(link_params)
    link = WebLink.new(link_params)
    link.parent_type = :project
    link.parent_key = self.key
    link
  end
  
  def next_action
    project_items_todo = self.action_items_todo.sort
    if project_items_todo.present?
      next_action = project_items_todo.first
    end
    next_action
  end
  
  def project_goals
    search_string = "project_key:#{self.key}"
    goal_docs = ProjectGoal.search_results_for(search_string)
  end
  
  # Hash by ProjectGoal key
  def project_goals_hash
    project_goals = self.project_goals
    project_goals = project_goals.map { |doc| ProjectGoal.from_search_result(doc) }
    project_goals_hash = Hash[project_goals.map {|pg| [pg.goal_key, pg]}]
  end
  
  def questions
    Question.for_parent(:project, self.key)
  end
  
  # Lazy-initialize accessor to :related_projects
  def related_projects
    @related_projects ||= []
  end
  
  def serve_goal_toggle(goal_key)
    goals_hash = self.project_goals_hash
    goal_ids = goals_hash.keys
    if goal_ids.include? goal_key
      # Stop serving goal - Delete the project-goal association
      project_goal_key = goals_hash[goal_key].key
      project_goal = ProjectGoal.find(project_goal_key)
      project_goal.destroy
    else
      project_goal = ProjectGoal.new(goal_key: goal_key, project_key: self.key)
      project_goal.save
    end
  end
  
  def time_elapsed(action_items)
    action_items.map(&:time_elapsed).sum
  end
  
  def self.active_projects
    self.all_for_status(:active)
  end
  
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
  
  def self.hash_by_status(projects)
    Util.hash_list_by(projects,:status)
  end
end
