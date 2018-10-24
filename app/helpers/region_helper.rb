module RegionHelper
  def region_label(region)
    if region == 'united_states'
      flag_icon(:us, id: 'my-flag', class: 'strong', title: 'United States')
    elsif region == 'latin_america'
      flag_icon(:do, id: 'my-flag', class: 'strong', title: 'Latin America')
    elsif region == 'canada'
      flag_icon(:ca, id: 'my-flag', class: 'strong', title: 'Canada')
    elsif region == 'india'
      flag_icon(:in, id: 'my-flag', class: 'strong', title: 'India')
    end
  end
end
