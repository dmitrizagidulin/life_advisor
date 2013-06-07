class ThoughtsController < ApplicationController
  # GET /thoughts
  # GET /thoughts.json
  def index
    @thoughts = Thought.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @thoughts }
    end
  end

  # GET /thoughts/1
  # GET /thoughts/1.json
  def show
    @thought = Thought.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @thought }
    end
  end

  # GET /thoughts/new
  # GET /thoughts/new.json
  def new
    @thought = Thought.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @thought }
    end
  end

  # GET /thoughts/1/edit
  def edit
    @thought = Thought.find(params[:id])
  end

  # POST /thoughts
  # POST /thoughts.json
  def create
    @thought = Thought.new(params[:thought])
    if @thought.parent_type == 'project'
      project = Project.find(@thought.parent_key)
      redirect_url = project_path(project) + '#thoughts_table'
    else
      redirect_url = thoughts_url
    end

    respond_to do |format|
      if @thought.save
        format.html { redirect_to redirect_url, notice: 'Thought was successfully created.' }
        format.json { render json: @thought, status: :created, location: @thought }
      else
        format.html { render action: "new" }
        format.json { render json: @thought.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /thoughts/1
  # PUT /thoughts/1.json
  def update
    @thought = Thought.find(params[:id])
    if @thought.parent_type == 'project'
      project = Project.find(@thought.parent_key)
      redirect_url = project_path(project) + '#thoughts_table'
    else
      redirect_url = thoughts_url
    end

    respond_to do |format|
      if @thought.update_attributes(params[:thought])
        format.html { redirect_to redirect_url, notice: 'Thought was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @thought.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /thoughts/1
  # DELETE /thoughts/1.json
  def destroy
    @thought = Thought.find(params[:id])
    if @thought.parent_type == 'project'
      project = Project.find(@thought.parent_key)
      redirect_url = project_path(project) + '#thoughts_table'
    else
      redirect_url = thoughts_url
    end
    @thought.destroy

    respond_to do |format|
      format.html { redirect_to redirect_url }
      format.json { head :no_content }
    end
  end
end
