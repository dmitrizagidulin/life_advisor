class ActionItemsController < ApplicationController
  # GET /action_items
  # GET /action_items.json
  def index
    @critical_items = ActionItem.all_todo(:critical).sort
    @opportunity_items = ActionItem.all_todo(:opportunity).sort
    @horizon_items = ActionItem.all_todo(:horizon).sort
    @someday_items = ActionItem.all_todo(:someday, focus_area=nil, include_projects=false).sort
    @tomorrow_items = ActionItem.all_todo(:tomorrow).sort
    @active_projects = Project.active_projects.select {|p| p.next_action }
    
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
  
  def bump
    @action_item = ActionItem.find(params[:id])
    if @action_item.belongs_to? :project
      project = Project.find(@action_item.parent_key)
      redirect_url = project_path(project)
    else
      redirect_url = action_items_url
    end
    
    @action_item.bump!
    respond_to do |format|
      format.html { redirect_to redirect_url, notice: "Bumped '#{@action_item.name}'"}
    end
  end
  
  def category_update
    @action_item = ActionItem.find(params[:id])
    @action_item.mywn_category = params[:category]
    session[:return_to] = request.referer || action_items_url # redirect to referring page
    respond_to do |format|
      if @action_item.save
        format.html { redirect_to session[:return_to] }
      end
    end
  end

  def category_update_all
    @from_category = params[:from_mywn_category]
    @to_category = params[:to_mywn_category]
    session[:return_to] = request.referer || action_items_url # redirect to referring page

    count_moved = ActionItem.mywn_category_move(@from_category, @to_category)
    respond_to do |format|
      format.html { redirect_to session[:return_to], notice: "#{count_moved} items moved from Tomorrow to Critical." }
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
    @parent = @action_item.parent
    @links = @action_item.links
    if @parent
      @back_link = url_for(@parent)
    else
      @back_link = action_items_path
    end
    
    
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
    @parent = @action_item.parent
  end

  # POST /action_items
  # POST /action_items.json
  def create
    @action_item = ActionItem.new(params[:action_item].permit(:name, :mywn_category, :area, :parent_type, :parent_key, :time_elapsed))

    respond_to do |format|
      if @action_item.save
        redirect_url = request.referer || action_items_url # redirect to referring page
        redirect_url += "##{@action_item.key}"

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
    if @action_item.belongs_to? :project
      redirect_url = @action_item.parent_url
    else
      redirect_url = request.referer || action_items_url # redirect to referring page
    end
    redirect_url += "##{@action_item.key}"
    
    respond_to do |format|
      if @action_item.update_attributes(params[:action_item].permit(:name, :mywn_category, :done, :completed_at, :time_elapsed, :description, :area, :parent_type, :parent_key))
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
    session[:return_to] = request.referer || action_items_url # redirect to referring page
    @action_item.destroy

    respond_to do |format|
      format.html { redirect_to session[:return_to] }
      format.json { head :no_content }
    end
  end
end
