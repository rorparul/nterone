class Admin::CoursesController < Admin::BaseController
  def index
    courses_scope = Course.active
    courses_scope = courses_scope.custom_search(params[:filter]) if params[:filter]

    @courses = smart_listing_create(:courses,
                                   courses_scope,
                                   partial: "admin/courses/listing",
                                   page_sizes: [100, 50, 10],
                                   sort_attributes: [
                                     [:title, "title"]
                                   ],
                                   default_sort: { title: "asc" })

    respond_to do |format|
      format.html
      format.js
    end
  end

  def toggle_exclude_from_revenue
    @course = Course.find(params[:id])
    if @course.exclude_from_revenue
      @course.update_attributes(exclude_from_revenue: false)
    else
      @course.update_attributes(exclude_from_revenue: true)
    end
    render json: {is_excluded: @course.exclude_from_revenue,course_id: @course.id, status: 200}
  end
end
