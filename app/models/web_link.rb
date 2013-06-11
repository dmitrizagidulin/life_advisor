require 'RippleSearch'
require 'Parentable'

class WebLink
  include Ripple::Document
  extend RippleSearch
  include Parentable
  
  property :name, String
  property :url, String, :presence => true
  timestamps!
end
