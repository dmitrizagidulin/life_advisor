require 'test_helper'

describe "a model implementing Parentable mixin" do
  it "can belong to a parent class" do
    item = ActionItem.new
    item.must_be_kind_of Parentable
    refute item.has_parent?, "A new action item should not have a parent by default"
    item.parent.must_be_nil
    
    item.parent_type = :project
    item.parent_key = '123'
    
    assert item.has_parent?
    item.parent_class.must_equal Project
    item.parent_url.must_equal "/projects/123"
  end
end