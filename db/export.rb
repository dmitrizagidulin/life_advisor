require 'fileutils'

def export_action_items(backup_dir, item_name, item_class)
  items = item_class.all
  puts "Exporting #{items.count} #{item_name}..."
#  item_dir = "#{backup_dir}/action_items"
#  puts "Creating #{item_dir}"
#  FileUtils::mkdir_p item_dir
  items_json = []
  items.each do | item |
    items_json.append(JSON.parse(item.to_json))
  end
  
  File.open("#{backup_dir}/#{item_name}.json","w") do |f|
    f.write(JSON.pretty_generate(items_json))
  end
end

def export_projects(backup_dir)
  all_projects = Project.all
  puts "Exporting #{all_projects.count} Projects..."
  projects_dir = "#{backup_dir}/projects"
  puts "Creating #{projects_dir}"
  FileUtils::mkdir_p projects_dir

  summary = {}
  active_projs = []
  inactive_projs = []
  projs_by_status = Project.hash_by_status(all_projects)

  [:active, :someday, :idea, :completed, :canceled].each do | status |
    puts "Exporting '#{status}' projects"
    status_dir = "#{projects_dir}/#{status}"
    FileUtils::mkdir_p status_dir
    status_list = []
    projs = projs_by_status[status.to_s] || []
    projs.sort.each do | project |
      status_list.append({ 'key' => project.key, 'name' => project.name })
      proj_file_name = "project-#{project.key}.json"
      payload = project.to_hash_for_export
      File.open("#{status_dir}/#{proj_file_name}","w") do |f|
        f.write(JSON.pretty_generate(payload))
      end
    end
    summary[status] = status_list
  end

  File.open("#{projects_dir}/summary.json","w") do |f|
    f.write(JSON.pretty_generate(summary))
  end
end

backup_dir = "/Users/koldun/data/life_advisor_export"
puts "Creating #{backup_dir}"
FileUtils::mkdir_p backup_dir

export_projects(backup_dir)
export_action_items(backup_dir, 'action_items', ActionItem)
export_action_items(backup_dir, 'links', WebLink)
export_action_items(backup_dir, 'questions', Question)
export_action_items(backup_dir, 'answers', Answer)
export_action_items(backup_dir, 'goals', Goal)
export_action_items(backup_dir, 'project-goals', ProjectGoal)
export_action_items(backup_dir, 'thoughts', Thought)

