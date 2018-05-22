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

  
end
