require 'active_support/concern'

module Parentable
  extend ActiveSupport::Concern
  include Ripple::Callbacks
  
  included do
    property :parent_type, String  # One of [:project, :day]
    property :parent_key, String  # (Optional) An action item can belong to a Project, or a day
  end
  
  module InstanceMethods
    def enforce_default_day_parent
      if not self.parent_type or (self.parent_type == 'day' and self.parent_key == 'today')
        self.parent_type = 'day'
        self.parent_key = Time.now.localtime.strftime('%Y-%m-%d')
      end
    end
    
    def belongs_to?(parent_type)
      self.parent_type == parent_type.to_s and self.parent_key.present?
    end
    
    def parent
      if self.parent_type and self.parent_type.to_sym == :project
        parent = Project.find(self.parent_key)
      end
      parent
    end
    
    def parent_url
      if self.parent_type.to_sym == :project
        return "/projects/#{self.parent_key}"
      end
    end
  end
  
  module ClassMethods
    def for_parent(parent_type, parent_key)
      search_string = "parent_type:#{parent_type} AND parent_key:#{parent_key}"
      results = self.search_results_for(search_string, sort_field='created_at desc')
      results.collect { |doc| self.from_search_result(doc) }
    end
  end
end