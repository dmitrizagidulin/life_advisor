class ProjectGoalsController < ApplicationController
  before_action :set_project_goal, only: [:show, :edit, :update, :destroy]

  # GET /project_goals
  # GET /project_goals.json
  def index
    @project_goals = ProjectGoal.all
  end

  # GET /project_goals/1
  # GET /project_goals/1.json
  def show
  end

  # GET /project_goals/new
  def new
    @project_goal = ProjectGoal.new
  end

  # GET /project_goals/1/edit
  def edit
  end

  # POST /project_goals
  # POST /project_goals.json
  def create
    @project_goal = ProjectGoal.new(project_goal_params)

    respond_to do |format|
      if @project_goal.save
        format.html { redirect_to @project_goal, notice: 'Project goal was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project_goal }
      else
        format.html { render action: 'new' }
        format.json { render json: @project_goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_goals/1
  # PATCH/PUT /project_goals/1.json
  def update
    respond_to do |format|
      if @project_goal.update(project_goal_params)
        format.html { redirect_to @project_goal, notice: 'Project goal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project_goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_goals/1
  # DELETE /project_goals/1.json
  def destroy
    @project_goal.destroy
    respond_to do |format|
      format.html { redirect_to project_goals_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_goal
      @project_goal = ProjectGoal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_goal_params
      params[:project_goal]
    end
end
