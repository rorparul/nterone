class SubjectsController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_subject,        only: [:show, :edit, :update, :destroy]
  before_action :set_category,       except: [:autocomplete]

  def show
    @platform = Platform.find(params[:platform_id])
    @subject  = Subject.find(params[:id])
    if user_signed_in? && current_user.sales_manager?
      @leads = Lead.where(status: 'unassigned', seller_id: [nil, 0]).order(created_at: :asc).where.not(buyer_id: nil)
    elsif user_signed_in? && current_user.sales_rep?
      @leads = Lead.where(status: 'assigned', seller_id: current_user.id).order(created_at: :asc).where.not(buyer_id: nil)
    end
  end

  def new
    @platform   = Platform.find(params[:platform_id])
    @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
      category if category.parent
    end
    @subject    = Subject.new
    @subject.build_image
  end

  def select
    @platform   = Platform.find(params[:platform_id])
    @categories = @platform.categories.order(:title).select do |category|
      category if category.parent
    end
    @subjects   = @platform.subjects.where.not(id: nil)
    @subject    = @platform.subjects.build
    @subject.build_image
  end

  def  select_to_edit
    @platform = Platform.find(params[:platform_id])
    @categories = @platform.categories.order(:title).select do |category|
      category if category.parent
    end
    if subject_params[:id] == 'none'
      @subjects   = @platform.subjects.where.not(id: nil)
      @subject    = @platform.subjects.build
      @subject.build_image
    else
      @subject  = Subject.find(subject_params[:id])
      @subject.build_image unless @subject.image.present?
    end
  end

  def edit
    @platform = Platform.find(params[:platform_id])
    @categories = @platform.categories.order(:title).select do |category|
      category if category.parent
    end
    @subject  = Subject.find(params[:id])
    @subject.build_image unless @subject.image.present?
  end

  def create
    @platform = Platform.find(params[:platform_id])
    @subject = @platform.subjects.build(subject_params)
    @subject.set_image(url_param: params['subject'], for: :image)
    if @subject.save
      flash['success'] = 'Certification successfully created!'
      redirect_to session[:previous_request_url]
    else
      @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
        category if category.parent
      end
      render 'new'
    end
  end

  def update
    @subject = Subject.find(params[:id])
    @subject.assign_attributes(subject_params)
    @subject.set_image(url_param: params['subject'], for: :image)
    if @subject.save
      flash['success'] = 'Certification successfully updated.'
      redirect_to session[:previous_request_url]
    else
      @platform = Platform.find(params[:platform_id])
      @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
        category if category.parent
      end
      render "edit"
    end
  end

  def destroy
    if @subject.destroy
      flash['success'] = 'Certification successfully deleted!'
    else
      flash['alert'] = 'Certification unsuccessfully deleted!'
    end
    redirect_to session[:previous_request_url]
  end

  private

  def set_subject
    @subject = Subject.find(params[:id])
  end

  def set_category
    @category = Category.find_by(id: params[:category_id])
  end

  def subject_params
    params.require(:subject).permit(
      :abbreviation,
      :active,
      :description,
      :heading,
      :id,
      :origin_region,
      :page_description,
      :page_title,
      :partner_led,
      :title,
      :type,
      active_regions: [],
      category_ids: [])
  end
end
