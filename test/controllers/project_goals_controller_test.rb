#require 'test_helper'
#
#class ProjectGoalsControllerTest < ActionController::TestCase
#  setup do
#    @project_goal = project_goals(:one)
#  end
#
#  test "should get index" do
#    get :index
#    assert_response :success
#    assert_not_nil assigns(:project_goals)
#  end
#
#  test "should get new" do
#    get :new
#    assert_response :success
#  end
#
#  test "should create project_goal" do
#    assert_difference('ProjectGoal.count') do
#      post :create, project_goal: {  }
#    end
#
#    assert_redirected_to project_goal_path(assigns(:project_goal))
#  end
#
#  test "should show project_goal" do
#    get :show, id: @project_goal
#    assert_response :success
#  end
#
#  test "should get edit" do
#    get :edit, id: @project_goal
#    assert_response :success
#  end
#
#  test "should update project_goal" do
#    patch :update, id: @project_goal, project_goal: {  }
#    assert_redirected_to project_goal_path(assigns(:project_goal))
#  end
#
#  test "should destroy project_goal" do
#    assert_difference('ProjectGoal.count', -1) do
#      delete :destroy, id: @project_goal
#    end
#
#    assert_redirected_to project_goals_path
#  end
#end
