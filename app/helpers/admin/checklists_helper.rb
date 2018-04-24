module Admin::ChecklistsHelper

  def checklist_item_event_modified_detail(event, item)
    checklist_items_event = event.checklist_items_events.where(checklist_item_id: item.id).first

    if checklist_items_event.present? && checklist_items_event.user.present?
      "#{checklist_items_event.user.name_initials} <br> #{checklist_items_event.updated_at.strftime("%d-%m-%Y")}".html_safe
    else
      nil
    end
  end
end
