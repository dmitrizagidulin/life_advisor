class ActionItemsController < ApplicationController
  # GET /action_items
  # GET /action_items.json
  def index
    @critical_items = ActionItem.all_todo(:critical)
    @opportunity_items = ActionItem.all_todo(:opportunity)
    @horizon_items = ActionItem.all_todo(:horizon)
    @someday_items = ActionItem.all_todo(:someday, include_projects=false)
    @tomorrow_items = ActionItem.all_todo(:tomorrow)
    @new_item = ActionItem.new
    
    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.json { render json: @action_items }
    end
  end

  def all
    @all_items = ActionItem.all # list keys
    
    respond_to do |format|
      format.html # all.html.erb
      format.json { render json: @all_items }
    end
  end
  
  def category_update
    @action_item = ActionItem.find(params[:id])
    @action_item.mywn_category = params[:category]
    respond_to do |format|
      if @action_item.save
        format.html { redirect_to action_items_url }
      end
    end
  end
  
  def completed
    @completed_items = ActionItem.all_completed
    
    respond_to do |format|
      format.html # completed.html.erb
      format.json { render json: @completed_items }
    end
  end

  
  # GET /action_items/1
  # GET /action_items/1.json
  def show
    @action_item = ActionItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @action_item }
    end
  end

  # GET /action_items/new
  # GET /action_items/new.json
  def new
    @action_item = ActionItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @action_item }
    end
  end

  # GET /action_items/1/edit
  def edit
    @action_item = ActionItem.find(params[:id])
  end

  # POST /action_items
  # POST /action_items.json
  def create
    @action_item = ActionItem.new(params[:action_item])

    if @action_item.project_key
      project = Project.find(@action_item.project_key)
      redirect_url = project_path(project)
    else
      redirect_url = action_items_url
    end
      
    respond_to do |format|
      if @action_item.save
        format.html { redirect_to redirect_url, notice: 'Action item created.' }
        format.json { render json: @action_item, status: :created, location: @action_item }
      else
        format.html { render action: "new" }
        format.json { render json: @action_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle_done
    @action_item = ActionItem.find(params[:id])
    @action_item.toggle_done!
    render :nothing => true
  end
  
  # PUT /action_items/1
  # PUT /action_items/1.json
  def update
    @action_item = ActionItem.find(params[:id])
    if @action_item.project_key
      project = Project.find(@action_item.project_key)
      redirect_url = project_path(project)
    else
      redirect_url = action_items_url
    end
    respond_to do |format|
      if @action_item.update_attributes(params[:action_item])
        format.html { redirect_to redirect_url, notice: 'Action item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @action_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /action_items/1
  # DELETE /action_items/1.json
  def destroy
    @action_item = ActionItem.find(params[:id])
    if @action_item.project_key
      project = Project.find(@action_item.project_key)
      redirect_url = project_path(project)
    else
      redirect_url = action_items_url
    end
    @action_item.destroy

    respond_to do |format|
      format.html { redirect_to redirect_url }
      format.json { head :no_content }
    end
  end
end
