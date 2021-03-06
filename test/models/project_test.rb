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
  
  test "Project hash by status method" do
    project_list = []
    project_list << (Project.new name: 'Active proj one', status: :active)
    project_list << (Project.new name: 'Active proj two', status: :active)
    project_list << (Project.new name: 'Completed proj', status: :completed)
    
    projects_by_status = Project.hash_by_status(project_list)
    projects_by_status['active'].count.must_equal 2
    projects_by_status['completed'][0].name.must_equal 'Completed proj'
  end
  
#  test "Project can have related projects" do
#    proj_one = test_project
#    refute proj_one.has_related?
#    
#    proj_two = Project.new name: 'Related Project'
#    proj_two.key = 'proj2'
#    
#    proj_one.add_related_project(proj_two.key)
#    assert proj_one.has_related?
#  end
end
