class Admin::SalesGoalsController < Admin::BaseController
  include FlyForm

  def new
    @sales_goal = SalesGoal.new
    render 'admin/shared/new'
  end

  def edit
    @sales_goal = SalesGoal.find(params[:id])
    render 'admin/shared/edit'
  end

  def create
    @sales_goal = SalesGoal.new(sales_goal_params)

    if @sales_goal.save
      fly_form('destroy')
    else
      fly_form('post')
      render 'admin/shared/new'
    end
  end

  def update
    @sales_goal = SalesGoal.find(params[:id])
    if @sales_goal.update(sales_goal_params)
      # flash[:success] = 'Sales goal successfully updated.'
      # redirect_to :back
    else
      render 'shared/edit'
    end
  end

  def index
    smart_listing_create(
      :sales_goals,
      SalesGoal.order('month desc, origin_region').all,
      partial: 'admin/sales_goals/listing',
      # sort_attributes: [
      #   [:created_at, 'opportunities.created_at'],
      #   [:stage, 'stage'],
      #   [:waiting, 'waiting'],
      #   [:date_closed, 'date_closed'],
      #   [:amount, 'amount']
      # ],
      default_sort: { month: 'desc' }
    )
  end

  def destroy
    @sales_goal = SalesGoal.find(params[:id])
    if @sales_goal.destroy
      flash[:success] = 'Sales goal successfully deleted.'
    else
      flash[:alert] = 'Sales goal failed to delete!'
    end
    redirect_to :back
  end

  private

  def sales_goal_params
    params.require(:sales_goal).permit(:origin_region, :month, :amount, :description)
  end

end
