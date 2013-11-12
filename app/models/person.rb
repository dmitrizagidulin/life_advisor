require 'RippleSearch'

class Person
  include Ripple::Document
  extend RippleSearch
  
  property :name, String, :presence => true
  property :description, String
  
  timestamps!
end
