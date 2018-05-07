module RegionHelper
  def region_label(resource)
    if resource.origin_region == 'united_states'
      ("<span class='label label-danger' title=#{resource.origin_region.titleize}>" +
        "US" +
      "</span>").html_safe
    elsif resource.origin_region == 'latin_america'
      ("<span class='label label-warning' title=#{resource.origin_region.titleize}>" +
        "LA" +
      "</span>").html_safe
    elsif resource.origin_region == 'canada'
      ("<span class='label label-info' title=#{resource.origin_region.titleize}>" +
        "CA" +
      "</span>").html_safe
    elsif resource.origin_region == 'india'
      ("<span class='label label-success' title=#{resource.origin_region.titleize}>" +
        "IN" +
      "</span>").html_safe
    else
      ("<span class='label label-default' title='Not Available'>" +
        "NA" +
      "</span>").html_safe
    end
  end
end
