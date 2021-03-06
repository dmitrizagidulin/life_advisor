class GoalsController < ApplicationController
  before_action :set_goal, only: [:show, :edit, :update, :destroy]

  # GET /goals
  # GET /goals.json
  def index
    @all_goals = Goal.all
    @accomplished_goals = @all_goals.select {|g| g.accomplished }
    @active_goals = @all_goals.select {|g| g.active and not g.accomplished }  # but unaccomplished
    @active_goals.sort!
    @inactive_goals = @all_goals.reject {|g| g.active or g.accomplished }
  end

  def bump
    set_goal
    @goal.bump!
    respond_to do |format|
      format.html { redirect_to goals_url, notice: "Bumped '#{@goal.name}'"}
    end
  end
  
  # GET /goals/1
  # GET /goals/1.json
  def show
    set_goal
    @projects = @goal.projects  # All projects serving this goal
    projects_by_status = Project.hash_by_status(@projects)
    @active_projects = projects_by_status['active']
    @sub_goals = @goal.sub_goals
    @parent = @goal.parent
  end

  # GET /goals/new
  def new
    @goal = Goal.new
  end

  # GET /goals/1/edit
  def edit
  end

  # POST /goals
  # POST /goals.json
  def create
    @goal = Goal.new(goal_params)
    
    if @goal.has_parent?
      redirect_url = @goal.parent_url
    else
      redirect_url = request.referer || goals_url # redirect to referring page
    end
    
    respond_to do |format|
      if @goal.save
        format.html { redirect_to redirect_url, notice: 'Goal was successfully created.' }
        format.json { render action: 'show', status: :created, location: @goal }
      else
        format.html { render action: 'new' }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /goals/1
  # PATCH/PUT /goals/1.json
  def update
    if @goal.has_parent?
      redirect_url = @goal.parent_url
    else
      redirect_url = request.referer || goals_url # redirect to referring page
    end

    respond_to do |format|
      if @goal.update(goal_params)
        format.html { redirect_to redirect_url, notice: 'Goal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goals/1
  # DELETE /goals/1.json
  def destroy
    if @goal.has_parent?
      redirect_url = @goal.parent_url
    else
      redirect_url = request.referer || goals_url # redirect to referring page
    end
    
    @goal.destroy
    respond_to do |format|
      format.html { redirect_to redirect_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_goal
      @goal = Goal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def goal_params
      params[:goal].permit(:name, :description, :active, :accomplished, :parent_type, :parent_key)
    end
end
