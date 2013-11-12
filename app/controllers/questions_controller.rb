class QuestionsController < ApplicationController
  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.all
    @project_questions = @questions.select {|q| q if q.parent_type == 'project' }
    @non_project_questions = @questions.select {|q| q unless q.parent_type == 'project' }
    puts @non_project_questions

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = Question.find(params[:id])
    @parent = @question.parent
    @answers = @question.answers
    @links = @question.links

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.json
  def new
    @question = Question.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(params[:question].permit(:name, :description, :parent_type, :parent_key))
    if @question.parent_type == 'project'
      project = Project.find(@question.parent_key)
      redirect_url = project_path(project) + '#questions_table'
    else
      redirect_url = questions_url
    end

    respond_to do |format|
      if @question.save
        format.html { redirect_to redirect_url, notice: 'Question was successfully created.' }
        format.json { render json: @question, status: :created, location: @question }
      else
        format.html { render action: "new" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def bump
    @question = Question.find(params[:id])
    if @question.parent_type == 'project'
      project = Project.find(@question.parent_key)
      redirect_url = project_path(project) + '#questions_table'
    else
      redirect_url = questions_url
    end
    
    @question.bump!
    respond_to do |format|
      format.html { redirect_to redirect_url, notice: "Bumped '#{@question.name}'"}
    end
  end
  
  # PUT /questions/1
  # PUT /questions/1.json
  def update
    @question = Question.find(params[:id])
    if @question.parent_type == 'project'
      project = Project.find(@question.parent_key)
      redirect_url = project_path(project) + '#questions_table'
    else
      redirect_url = questions_url
    end

    respond_to do |format|
      if @question.update_attributes(params[:question].permit(:name, :description, :parent_type, :parent_key))
        format.html { redirect_to redirect_url, notice: 'Question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question = Question.find(params[:id])
    if @question.parent_type == 'project'
      project = Project.find(@question.parent_key)
      redirect_url = project_path(project) + '#questions_table'
    else
      redirect_url = questions_url
    end

    @question.destroy
    respond_to do |format|
      format.html { redirect_to redirect_url }
      format.json { head :no_content }
    end
  end
end
