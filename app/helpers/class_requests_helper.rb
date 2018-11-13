module ClassRequestsHelper
  def total_unprocessed_class_requests_badge
    if current_user.sales_rep?
      count = Event.unscoped.where(approved: false, sales_rep_id: current_user.id).count
    elsif current_user.admin? || current_user.sales_manager?
      count = Event.unscoped.where(approved: false).count
    end

    if count > 0
      "<span class='badge badge-success'>#{count}</span> ".html_safe
    end
  end
end
