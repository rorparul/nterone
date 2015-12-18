class SubjectsController < ApplicationController
  before_action :set_subject,        only: [:show, :edit, :update, :destroy]
  before_action :set_category,       except: [:autocomplete]
  before_action :authenticate_user!, except: [:index, :show, :autocomplete]
  # before_action :authorize_subject, except: [:index, :show, :autocomplete]
  # after_action  :verify_authorized, except: [:index, :show, :autocomplete]

  def index
    @subjects = @category.subjects
  end

  def show
    @platform = Platform.find(params[:platform_id])
    @subject  = Subject.find(params[:id])
    if user_signed_in? && current_user.sales_manager?
      @leads = Lead.where(status: 'unassigned', seller_id: [nil, 0]).order(created_at: :asc)
    elsif user_signed_in? && current_user.sales_rep?
      @leads = Lead.where(status: 'assigned', seller_id: current_user.id).order(created_at: :asc)
    end
  end

  def new
    @platform   = Platform.find(params[:platform_id])
    @categories = Category.where(platform_id: @platform.id).select do |category|
      category if category.parent
    end
    @subject    = Subject.new
    @subject.build_image
  end

  def select
    @platform   = Platform.find(params[:platform_id])
    @categories = @platform.categories.select do |category|
      category if category.parent
    end
    @subjects   = @platform.subjects.where.not(id: nil)
    @subject    = @platform.subjects.build
    @subject.build_image
  end

  def  select_to_edit
    if subject_params[:id] == 'none'
      redirect_to select_platform_subjects_path(Platform.find(params[:platform_id]))
    else
      @platform = Platform.find(params[:platform_id])
      @categories = Category.where(platform_id: @platform.id).select do |category|
        category if category.parent
      end
      @subject  = Subject.find(subject_params[:id])
      @subject.build_image unless @subject.image.present?
    end
  end

  def create
    @subject = Platform.find(params[:platform_id]).subjects.new(subject_params)
    @subject.set_image(url_param: params['subject'], for: :image)
    if @subject.save
      flash['notice'] = 'Certification was successfully created.'
      redirect_to platform_subject_path(Platform.find(params[:platform_id]), @subject.id)
    else
      render('new')
    end
  end

  def update
    @subject = Subject.find(params[:id])
    @subject.assign_attributes(subject_params)
    @subject.set_image(url_param: params['subject'], for: :image)
    if @subject.save
      flash['notice'] = 'Certification was successfully updated.'
      redirect_to platform_path(Platform.find(params[:platform_id]))
    else
      render('edit')
    end
  end

  def destroy
    @subject.destroy
    flash['notice'] = 'Certification was successfully deleted.'
    redirect_to platform_path(Platform.find(params[:platform_id]))
  end

  private

  def set_subject
    @subject = Subject.find(params[:id])
  end

  def set_category
    @category = Category.find_by(id: params[:category_id])
  end

  def subject_params
    params.require(:subject).permit(:id, :title, :abbreviation, :description, :type, category_ids: [])
  end

  def authorize_subject
    @subject ||= Subject.new
    authorize @subject
  end
end
