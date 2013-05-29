class ActionItemsController < ApplicationController
  # GET /action_items
  # GET /action_items.json
  def index
    @critical_items = ActionItem.all_todo(:critical)
    @opportunity_items = ActionItem.all_todo(:opportunity)
    @horizon_items = ActionItem.all_todo(:horizon)
    @someday_items = ActionItem.all_todo(:someday, focus_area=nil, include_projects=false)
    @tomorrow_items = ActionItem.all_todo(:tomorrow)
    
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
    @action_item = ActionItem.new(params[:action_item])

    session[:return_to] = request.referer || action_items_url # redirect to referring page
      
    respond_to do |format|
      if @action_item.save
        format.html { redirect_to session[:return_to], notice: 'Action item created.' }
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
    if @action_item.has_parent?
      session[:return_to] = @action_item.parent_url
    else
      session[:return_to] = request.referer || action_items_url # redirect to referring page
    end

    respond_to do |format|
      if @action_item.update_attributes(params[:action_item])
        format.html { redirect_to session[:return_to], notice: 'Action item was successfully updated.' }
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
