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
  
  test "Projects should be sorted in descending bump count order" do
    project_list = []
    proj_zero = Project.new name: 'Test project, zero bumps'
    
    proj_one = Project.new name: 'Test project, one bump'
    proj_one.bump
    
    proj_two = Project.new name: 'Test project, two bumps'
    2.times { proj_two.bump } 

    project_list << proj_one
    project_list << proj_zero
    project_list << proj_two
    
    project_list.sort!
    project_list[0].name.must_equal 'Test project, two bumps'
  end
  
  test "For projects with same bump count, sort in ascending alpha order by name" do
    project_list = []
    proj_one = Project.new name: 'Test Project A'
    proj_two = Project.new name: 'Test Project B'
    proj_three = Project.new name: 'Test Project C'
    
    project_list << proj_two
    project_list << proj_three
    project_list << proj_one
    project_list.sort!
    project_list[0].name.must_equal 'Test Project A'
  end
end
