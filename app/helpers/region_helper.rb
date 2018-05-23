module RegionHelper
  def region_label(resource)
    if resource.origin_region == 'united_states'
      flag_icon(:us, id: 'my-flag', class: 'strong', title: 'United States')
    elsif resource.origin_region == 'latin_america'
      flag_icon(:do, id: 'my-flag', class: 'strong', title: 'Latin America')
    elsif resource.origin_region == 'canada'
      flag_icon(:ca, id: 'my-flag', class: 'strong', title: 'Latin America')
    elsif resource.origin_region == 'india'
      flag_icon(:in, id: 'my-flag', class: 'strong', title: 'India')
    end
  end
end
