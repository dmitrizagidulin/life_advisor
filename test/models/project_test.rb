require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "should not validate empty project" do
    project = Project.new
    refute project.valid?
  end
  
  test "New project should have no action items associated with it" do
    project = Project.new
#    assert_empty project.action_items
  end
end
