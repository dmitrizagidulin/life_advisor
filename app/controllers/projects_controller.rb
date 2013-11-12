class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  def index
#    @projects = Project.all
    @idea_projects = Project.all_for_status(:idea).sort
    @active_projects = Project.all_for_status(:active).sort
    @someday_projects = Project.all_for_status(:someday).sort

    respond_to do |format|
      format.html # index.html.erb
#      format.json { render json: @projects }
    end
  end

  def all
    @all_items = Project.all # list keys
    
    respond_to do |format|
      format.html # all.html.erb
      format.json { render json: @all_items }
    end
  end

  def canceled
    @canceled_projects = Project.all_for_status(:canceled)
    respond_to do |format|
      format.html # canceled.html.erb
    end
  end
    
  def completed
    @completed_projects = Project.all_for_status(:completed)
    respond_to do |format|
      format.html # completed.html.erb
    end
  end
  
  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])
    @action_items = @project.action_items_todo.sort
    @completed_items = @project.action_items_completed.sort {|x,y| y <=> x}
    @num_action_items_total = @action_items.count + @completed_items.count
    @elapsed_time_completed = @project.time_elapsed(@completed_items)
    @elapsed_time_todo = @project.time_elapsed(@action_items)
    @elapsed_time_total = @elapsed_time_completed + @elapsed_time_todo
    
    @links = @project.links
    @questions = @project.questions
    @goals_served = @project.goals_served
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  def serve_goal_toggle
    goal_key = params[:goal_key]
    project_key = params[:project_key]
    project = Project.find(project_key)
    project.serve_goal_toggle(goal_key)
    render :nothing => true
  end
  
  def set_goals
    @project = Project.find(params[:id])
    @goal_ids = @project.goal_ids
    @active_goals = Goal.active_goals
    
    respond_to do |format|
      format.html # set_goals.html.erb
    end
  end
  
  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
#        redirect_url = projects_url + "#project-" + @project.key
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def bump
    @project = Project.find(params[:id])
    @project.bump!
    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Bumped '#{@project.name}'"}
    end
  end
  
  def status_update
    @project = Project.find(params[:id])
    @project.change_status! params[:status]
    
    if @project.status.to_sym == :completed
      new_url = '/projects/completed'
    elsif @project.status.to_sym == :canceled
      new_url = '/projects/canceled'
    else
      new_url = @project
    end
      
    respond_to do |format|
      if @project.save
        format.html { redirect_to new_url }
      end
    end
  end
  
  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(project_params)
#        redirect_url = projects_url  + "#project-" + @project.key
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end
  
  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params[:project].permit(:name, :description, :status, :area, :parent_type, :parent_key, :url, :bump_count)
  end
end
