class TasksController < ApplicationController
  before_action :validate_task
  before_action :set_task, except: [:index, :create, :complete]

  def index
    index_tasks
  end

  def show
  end

  def new
    form_data
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      find_path
    else
      render 'new'
    end
  end

  def edit
    form_data
  end

  def update
    if @task.update_attributes(task_params)
      find_path
    else
      render 'edit'
    end
  end

  def complete
    task = Task.find(params[:task_id])
    task.update_attribute(:complete, params[:task][:complete])
    find_path
  end

  def destroy
    @task.destroy
    redirect_to :back
  end

  private

  def task_params
    params.require(:task).permit(
      :activity_date,
      :complete,
      :description,
      :priority,
      :rep_id,
      :subject,
      :user_id
    )
  end

  def index_tasks
    @tasks = Task.where(rep_id: current_user.id, complete: false).order(:activity_date)
  end

  def find_path
    if params[:task][:user_page] == 'false'
      index_tasks
      render 'index'
    else
      render js: "window.location = '#{request.referrer}';"
    end
  end

  def form_data
    @user = User.find(params[:user_id]) if params[:user_id]
    @priorities = [
      ["Low", 1],
      ["Normal", 2],
      ["High", 3]
    ]
  end

  def set_task
    @task = Task.find_by(id: params[:id]) || Task.new
  end

  def validate_task

  end
end
