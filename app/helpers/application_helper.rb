module ApplicationHelper
  def welcome_page?
    controller_name == 'welcome' && action_name == 'index'
  end

  def number_to_currency(number, options = {})
    options[:locale] ||= :en
    super(number, options)
  end

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

  def us_states
    [
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
  end

  def canadian_provinces
    [
      ["Alberta", "AB"],
      ["British Columbia", "BC"],
      ["Manitoba", "MB"],
      ["New Brunsick", "NB"],
      ["Newfoundland and Labrador", "NL"],
      ["Nova Scotia", "NS"],
      ["Northwest Territories", "NT"],
      ["Nunavut", "NU"],
      ["Ontario", "ON"],
      ["Prince Edward Island", "PE"],
      ["Quebec", "QC"],
      ["Saskatchewan", "SK"],
      ["Yukon", "YT"]
    ]
  end

  def country_regions
    [
      ["United States", us_states],
      ["Canada", canadian_provinces]
    ]
  end

  def current_country
    "US"
  end

  def link_to_add_fields(name, f, association, class_attribute="")
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields2 #{class_attribute}", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def angular_templates templates_path
    templates = Dir[templates_path + '**/*'].select { |f| File.file? f }
    templates.inject("") do |js, template|
      rendered = render file: template
      template_id = Pathname.new(template.gsub(/\.(\w+)$/, '')).relative_path_from(Pathname.new(templates_path))
      js += "<script type='text/ng-template' id='#{template_id.to_s}'>#{rendered}</script>"
    end
  end

  def human_boolean(boolean)
      boolean ? 'Yes' : 'No'
  end


  def courses_for_select
    Course.active.includes(:platform).order('platforms.title', 'lower(abbreviation)')
  end
    

  def show_error(input, object)
    if object.errors.full_messages.any?
      if !object.errors.messages[input].blank?
        object.errors.messages[input].join(",")
      end
    end
  end
end
