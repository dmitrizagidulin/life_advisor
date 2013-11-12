require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "should not validate empty project" do
    project = Project.new
    refute project.valid?
  end
  
  test "New project should have a Bump count of 0" do
    project = Project.new
    project.bump_count.must_equal 0
  end
  
  test "Bumping a new project should result in a bump count of 1" do
    project = Project.new
    project.bump
    project.bump_count.must_equal 1
  end
end
