after :courses do
  Course.all.each do |course|
    Event.create(
      start_date: DateTime.current,
      end_date: DateTime.current.advance(months: 1),
      format: "ClearConnect",
      price: 11,
      instructor_id: nil,
      course_id: course.id,
      guaranteed: true,
      active: true,
      start_time: DateTime.current,
      end_time: DateTime.current.advance(hours: 1),
      city: 'Tbilisi',
      state: 'GA',
      cost_instructor: 0,
      cost_lab: 1,
      cost_te: 2,
      cost_facility: 1,
      cost_books: 1,
      cost_shipping: 1
    )
  end
end
