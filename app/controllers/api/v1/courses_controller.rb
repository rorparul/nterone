class Api::V1::CoursesController < Api::V1::BaseController
  autocomplete :course, :title
end
