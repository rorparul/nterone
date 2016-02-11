class GroupsController < ApplicationController
  before_action :authenticate_user!

  def new
    @platform                 = Platform.find(params[:platform_id])
    @subject                  = Subject.find(params[:subject_id])
    @group                    = @subject.groups.build
    @subjects                 = @platform.subjects
    @courses                  = @platform.courses
    @exam_and_course_dynamics = @platform.exam_and_course_dynamics
    @dividers                 = @platform.dividers
    @custom_items             = @platform.custom_items.where(is_header: false)
  end

  def create
    @platform = Platform.find(params[:platform_id])
    @subject  = Subject.find(params[:subject_id])
    @group    = @subject.groups.build(group_params)
    if @group.save
      flash['success'] = 'Table successfully created!'
      render js: "window.location = '#{request.referrer}';"
    else
      @subjects                 = @platform.subjects
      @courses                  = @platform.courses
      @exam_and_course_dynamics = @platform.exam_and_course_dynamics
      @dividers                 = @platform.dividers
      @custom_items             = @platform.custom_items.where(is_header: false)
      render 'new'
    end
  end

  def edit
    @platform                 = Platform.find(params[:platform_id])
    @subject                  = Subject.find(params[:subject_id])
    @group                    = Group.find(params[:id])
    @subjects                 = @platform.subjects
    @courses                  = @platform.courses
    @exam_and_course_dynamics = @platform.exam_and_course_dynamics
    @dividers                 = @platform.dividers
    @custom_items             = @platform.custom_items.where(is_header: false)
  end

  def update
    @platform = Platform.find(params[:platform_id])
    @subject  = Subject.find(params[:subject_id])
    @group    = Group.find(params[:id])
    @group.assign_attributes(group_params)
    if @group.save
      flash['success'] = 'Table successfully updated!'
      render js: "window.location = '#{request.referrer}';"
    else
      @subjects                 = @platform.subjects
      @courses                  = @platform.courses
      @exam_and_course_dynamics = @platform.exam_and_course_dynamics
      @dividers                 = @platform.dividers
      @custom_items             = @platform.custom_items
      render 'edit'
    end
  end

  def destroy
    group = Group.find(params[:id])
    if group.destroy
      flash['success'] = 'Table successfully deleted!'
    else
      flash['alert'] = 'Table unsuccessfully deleted!'
    end
    redirect_to :back
  end

  private

  def group_params
    params.require(:group).permit(:header, :subject_ids,
      group_items_attributes: [:id,
                               :position,
                               :groupable_type,
                               :groupable_id,
                               :updated_at,
                               :_destroy]
    )
  end
end
