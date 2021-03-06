require 'active_support/concern'

module Parentable
  extend ActiveSupport::Concern
  include Ripple::Callbacks
  
  included do
    property :parent_type, String  # One of [:project, :day, :question]
    property :parent_key, String  # (Optional) 
  end
  
  def persist!
    @new = false
  end
  
#  module InstanceMethods
    def enforce_default_day_parent
      if not self.parent_type or (self.parent_type == 'day' and self.parent_key == 'today')
        self.parent_type = 'day'
        self.parent_key = Time.now.localtime.strftime('%Y-%m-%d')
      end
    end
    
    def has_parent?
      self.parent_type.present? && self.parent_key.present?
    end
    
    def parent_class
      self.parent_type.to_s.classify.constantize
    end
    
    def parent
      return nil if self.parent_key.blank?
      return nil if self.parent_type.to_s == 'day'
      if self.parent_type
        parent = self.parent_class.find(self.parent_key)
      end
      parent
    end
    
    def parent_url
      parent_instance = self.parent_class.new
      "/#{parent_instance.class.bucket_name}/#{self.parent_key}"
    end
#  end  #  module InstanceMethods
  
  module ClassMethods
    def for_parent(parent_type, parent_key)
      search_string = "parent_type:#{parent_type} AND parent_key:#{parent_key}"
      results = self.search_results_for(search_string, sort_field='created_at desc')
      results.collect { |doc| self.from_search_result(doc) }
    end
  end
end