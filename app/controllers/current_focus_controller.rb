class CurrentFocusController < ApplicationController
  # POST /current_focus/add_bookmark.json
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
  
  # POST /current_focus/edit
  def edit
    @new_focus = CurrentFocus.new(params.permit(:focus_type, :focus_key))
    @focus_instance = @new_focus.load_instance
    @new_focus = CurrentFocus.on(@focus_instance)
    respond_to do |format|
      if @new_focus.save
        format.html { redirect_to @focus_instance  }
        format.json { head :ok }
      else
        format.json { render json: @new_focus.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # POST /current_focus/reset
  def reset
    result = Elefsis.reset_focus!
    respond_to do |format|
      if result
        format.js { head :ok }
#        format.json { head :ok }
      else
        format.json { render json: result.errors, status: :unprocessable_entity }
      end
    end
  end
end