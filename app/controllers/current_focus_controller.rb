class CurrentFocusController < ApplicationController
  # POST /current_focus/add_bookmark
  def add_bookmark
    @current_focus = Elefsis.current_focus
    @web_link = @current_focus.new_link(params.permit(:name, :url))
    
    respond_to do |format|
      if @web_link.save
        format.json { head :ok }
      else
        format.json { render json: @web_link.errors, status: :unprocessable_entity }
      end
    end
  end
end