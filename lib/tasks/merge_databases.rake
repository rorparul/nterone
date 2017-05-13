namespace "db" do
  task "merge" => :environment do
    @database = 'nterone-la'
    process_model(Course, 
      %i[title], 
      [CategoryCourse, ChosenCourse, DiscountFilter, Event, LabCourseTimeBlock, LabRental, Opportunity, Testimonial, VideoOnDemand])
    # process_model(Event, %i[start_date start_time end_date end_time time_zone format price zipcode state city street origin_region])
  end

  def process_model(model, uniq_fields, relations)
    ActiveRecord::Base.establish_connection(@database)
    records = model.all.to_a
    ActiveRecord::Base.establish_connection('development')
    records.each do |record|
      condition = {}
      uniq_fields.each do |field|
        condition[field] = record.send(field)
      end
      found = model.where(condition)
      if found.count > 0
        ap found.first
        ap record
      end
    end
  end
end