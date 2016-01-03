module ApplicationHelper
  def form_wraper
    content_tag(:div, class: 'col-xs-7 col-sm-5 col-md-4 col-lg-3 form-container' ) do
      yield
    end
  end

  def display_category_operation(operation)
    return 'and' if operation == '*'
    return 'or' if operation == '+'
    ''
  end

  # def form_errors(resource)
  #   if resource.errors.any?
  #     "<div class='alert alert-danger alert-dismissible'>" +
  #       "<button class='close' type='button' data-dismiss='alert' aria-label='Close'>" +
  #         "<span aria-hidden='true'>&times;<span/>" +
  #       "<h4>#{pluralize(resource.errors.count, 'error')}:<h4/>" +
  #       "<ul>"
  #         resource.errors.full_messages.each do |msg|
  #           li = msg
  # end
end
