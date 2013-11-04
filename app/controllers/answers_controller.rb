class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]

  # GET /answers
  # GET /answers.json
  def index
    @answers = Answer.all
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
  end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1/edit
  def edit
  end

  # POST /answers
  # POST /answers.json
  def create
    @answer = Answer.new(answer_params)
    if @answer.parent_type == 'question'
      question = Question.find(@answer.parent_key)
      redirect_url = question_path(question) + '#answers_table'
    else
      redirect_url = answers_url
    end
    respond_to do |format|
      if @answer.save
        format.html { redirect_to redirect_url, notice: 'Answer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @answer }
      else
        format.html { render action: 'new' }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
    @answer = Answer.find(params[:id])
    if @answer.parent_type == 'question'
      question = Question.find(@answer.parent_key)
      redirect_url = question_path(question) + '#answers_table'
    else
      redirect_url = answers_url
    end
    
    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to redirect_url, notice: 'Answer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    @answer = Answer.find(params[:id])
    if @answer.parent_type == 'question'
      question = Question.find(@answer.parent_key)
      redirect_url = question_path(question) + '#answers_table'
    else
      redirect_url = answers_url
    end
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to redirect_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params[:answer].permit(:name, :description, :parent_type, :parent_key)
    end
end
