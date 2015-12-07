# class GroupItemsController < ApplicationController
#   def selector
#     @platform = Platform.find(params[:platform_id])
#     @type     = params[:type]
#     case @type
#     when 'subject'
#       @objects = @platform.subjects
#     when 'exam'
#       @objects = @platform.exams
#     when 'course'
#       @objects = @platform.courses
#     when 'divider'
#       @objects = @platform.dividers
#     when 'custom_item'
#       @objects = @platform.custom_items
#     end
#   end
# end
