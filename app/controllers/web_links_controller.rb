class WebLinksController < ApplicationController
  layout 'bookmark', :only => [:bookmark]
  
  # GET /web_links/bookmark
  # Bookmarklet code:
  # <code>
  # javascript:window.open('http://localhost:3000/web_links/bookmark?url='+encodeURIComponent(location.href)+'&name='+encodeURIComponent(document.title),
  # 'newWindowName','width=775,height=450,scrollbars=no,status=no,titlebar=no,toolbar=no');void(0);
  # </code>
  def bookmark
    @web_link = WebLink.new(params.permit([:name, :url]))
  end
  
  # POST /web_links/bookmark
  def create_bookmark
    @current_focus = Elefsis.current_focus
    @web_link = @current_focus.new_link(params[:web_link].permit(:name, :url, :description))
    
    respond_to do |format|
      if @web_link.save
        format.html { head :ok }
        format.js { head :ok }
      else
        format.json { render json: @web_link.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /web_links
  # GET /web_links.json
  def index
    @web_links = WebLink.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @web_links }
    end
  end

  # GET /web_links/1
  # GET /web_links/1.json
  def show
    @web_link = WebLink.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @web_link }
    end
  end

  # GET /web_links/new
  # GET /web_links/new.json
  def new
    @web_link = WebLink.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @web_link }
    end
  end

  # GET /web_links/1/edit
  def edit
    @web_link = WebLink.find(params[:id])
  end

  # POST /web_links
  # POST /web_links.json
  def create
    @web_link = WebLink.new(web_link_params)
    if @web_link.parent_type == 'project'
      project = Project.find(@web_link.parent_key)
      redirect_url = project_path(project) + '#links_table'
    elsif @web_link.parent_type == 'action_item'
      action_item = ActionItem.find(@web_link.parent_key)
      redirect_url = action_item_path(action_item) + '#links_table'
    elsif @web_link.parent_type == 'question'
            question = Question.find(@web_link.parent_key)
            redirect_url = question_path(question) + '#links_table'
    else
      redirect_url = web_links_url
    end
    
    respond_to do |format|
      if @web_link.save
        format.html { redirect_to redirect_url, notice: 'Link was successfully created.' }
        format.json { render json: @web_link, status: :created, location: @web_link }
      else
        format.html { render action: "new" }
        format.json { render json: @web_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /web_links/1/to_action_item
  def to_action_item
    @web_link = WebLink.find(params[:id])
    redirect_url = @web_link.parent_url
    
    respond_to do |format|
      action_item = ActionItem.from_web_link @web_link
      if action_item.save
        action_item.save_related()
        @web_link.destroy!
      end
      format.html { redirect_to redirect_url, notice: 'Converted to ActionItem' }
    end
  end
  
  # PUT /web_links/1
  # PUT /web_links/1.json
  def update
    @web_link = WebLink.find(params[:id])
    if @web_link.parent_type == 'project'
      project = Project.find(@web_link.parent_key)
      redirect_url = project_path(project) + '#links_table'
    elsif @web_link.parent_type == 'action_item'
        action_item = ActionItem.find(@web_link.parent_key)
        redirect_url = action_item_path(action_item) + '#links_table'
    elsif @web_link.parent_type == 'question'
          question = Question.find(@web_link.parent_key)
          redirect_url = question_path(question) + '#links_table'
    else
      redirect_url = web_links_url
    end
    
    respond_to do |format|
      if @web_link.update_attributes(web_link_params)
        format.html { redirect_to redirect_url, notice: 'Web link was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @web_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /web_links/1
  # DELETE /web_links/1.json
  def destroy
    @web_link = WebLink.find(params[:id])
    if @web_link.parent_type == 'project'
      project = Project.find(@web_link.parent_key)
      redirect_url = project_path(project) + '#links_table'
    elsif @web_link.parent_type == 'action_item'
      action_item = ActionItem.find(@web_link.parent_key)
      redirect_url = action_item_path(action_item) + '#links_table'
    else
      redirect_url = web_links_url
    end
    @web_link.destroy
    respond_to do |format|
      format.html { redirect_to redirect_url }
      format.json { head :no_content }
    end
  end
  
  private
  def web_link_params
    params[:web_link].permit(:name, :url, :description, :parent_type, :parent_key)
  end
end
