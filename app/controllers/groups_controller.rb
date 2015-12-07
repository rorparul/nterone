class GroupsController < ApplicationController
  def new
    @platform                 = Platform.find(params[:platform_id])
    @subject                  = Subject.find(params[:subject_id])
    @group                    = @platform.groups.build
    @subjects                 = @platform.subjects
    @courses                  = @platform.courses
    @exam_and_course_dynamics = @platform.exam_and_course_dynamics
    @dividers                 = @platform.dividers
    @custom_items             = @platform.custom_items.where(is_header: false)
  end

  def create
    # TODO: Associate platform with group
    @platform = Platform.find(params[:platform_id])
    @subject  = Subject.find(params[:subject_id])
    @group    = @subject.groups.new(group_params)
    if @group.save
      flash['success'] = 'Table successfully created!'
      redirect_to :back
    else
      flash['alert'] = 'Table unsuccessfully created!'
      redirect_to :back
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
    @custom_items             = @platform.custom_items
  end

  def update
    @platform = Platform.find(params[:platform_id])
    @subject  = Subject.find(params[:subject_id])
    @group    = Group.find(params[:id])
    if @group.update_attributes(group_params)
      flash['success'] = 'Table successfully updated.'
      redirect_to :back
    else
      flash['alert'] = 'Table unsuccessfully to updated.'
      redirect_to :back
    end
  end

  def destroy
    @platform = Platform.find(params[:platform_id])
    @subject  = Subject.find(params[:subject_id])
    @group    = Group.find(params[:id])
    if @group.destroy
      flash['success'] = 'Table successfully deleted.'
      redirect_to :back
    else
      flash['alert'] = 'Table unsuccessfully deleted.'
      redirect_to :back
    end
  end

  private

  def group_params
    params.require(:group).permit(:header, :subject_ids,
      group_items_attributes: [:id, :position, :groupable_type, :groupable_id, :updated_at, :_destroy]
    )
  end
end
