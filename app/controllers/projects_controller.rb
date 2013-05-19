class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  def index
#    @projects = Project.all
    @idea_projects = Project.all_for_status(:idea)
    @active_projects = Project.all_for_status(:active)
    @someday_projects = Project.all_for_status(:someday)
    @new_item = Project.new

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
    @action_items = @project.action_items
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
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
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_url, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
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
      new_url = projects_url
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
      if @project.update_attributes(params[:project])
        format.html { redirect_to projects_url, notice: 'Project was successfully updated.' }
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
end
