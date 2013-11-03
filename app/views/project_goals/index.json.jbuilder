json.array!(@project_goals) do |project_goal|
  json.extract! project_goal, 
  json.url project_goal_url(project_goal, format: :json)
end
