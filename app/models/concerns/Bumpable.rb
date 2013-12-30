require 'active_support/concern'

module Bumpable
  extend ActiveSupport::Concern
  
  included do
    property :bump_count, Integer, default: 0
  end
  
  def bump
    self.bump_count += 1
  end
  
  def bump!
    self.bump
    self.save
  end
end