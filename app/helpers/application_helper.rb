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
end
