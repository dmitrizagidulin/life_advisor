class WebLinksController < ApplicationController
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
    @web_link = WebLink.new(params[:web_link])

    respond_to do |format|
      if @web_link.save
        format.html { redirect_to @web_link, notice: 'Web link was successfully created.' }
        format.json { render json: @web_link, status: :created, location: @web_link }
      else
        format.html { render action: "new" }
        format.json { render json: @web_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /web_links/1
  # PUT /web_links/1.json
  def update
    @web_link = WebLink.find(params[:id])

    respond_to do |format|
      if @web_link.update_attributes(params[:web_link])
        format.html { redirect_to @web_link, notice: 'Web link was successfully updated.' }
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
    @web_link.destroy

    respond_to do |format|
      format.html { redirect_to web_links_url }
      format.json { head :no_content }
    end
  end
end
