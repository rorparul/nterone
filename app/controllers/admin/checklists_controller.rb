class Admin::ChecklistsController < Admin::BaseController

  def index
    checklists_scope = Checklist.all
    # checklists_scope = checklists_scope.custom_search(cookies[:filter]) if cookies[:filter]

    @checklists = smart_listing_create(:checklists,
                                   checklists_scope,
                                   partial: "admin/checklists/listing",
                                   page_sizes: [100, 50, 10],
                                   sort_attributes: [
                                     [:name, "name"]
                                   ],
                                   default_sort: { name: "asc" })

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @checklist = Checklist.new
  end

  def edit
    @checklist = Checklist.find(params[:id])
  end

  def create
    @checklist = Checklist.new(checklist_params)
    result = @checklist.save
    if result
      flash[:success] = 'Checklist successfully created!'
      render js: "window.location = '#{request.referrer}';"
    else
      render 'new'
    end
  end

  def update
    @checklist = Checklist.find(params[:id])
    result = @checklist.update_attributes(checklist_params)
    if result
      flash[:success] = 'Checklist successfully updated!'
      render js: "window.location = '#{request.referrer}';"
    else
      render 'new'
    end
  end

  def destroy
    @checklist = Checklist.find(params[:id])
    result = @checklist.destroy
    if result
      flash[:success] = 'Checklist successfully destroyed!'
    else
      flash[:alert] = 'Checklist failed to destroy!'
    end
    redirect_to :back
  end

  def show
    @checklist = Checklist.find(params[:id])
    @event = Event.find(params[:event_id])
  end

  def complete_item
    @event = Event.find(params[:event_id])
    @checklist_item = ChecklistItem.find(params[:id])
    @event.checklist_items << @checklist_item
    success = @event.checklist_items.exists? @checklist_item.id
    render json: { success: success }, status: success ? 200 : 404
  end

  def uncomplete_item
    @event = Event.find(params[:event_id])
    @checklist_item = ChecklistItem.find(params[:id])
    success = @event.checklist_items.destroy(@checklist_item)
    render json: { success: success }, status: success ? 200 : 404
  end

  private

  def checklist_params
    params.require(:checklist).permit(:name, items_attributes: [
      :id,
      :_destroy,
      :content
    ])
  end

end
