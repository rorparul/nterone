after :platforms do
  category = Category.first

  Platform.all.each do |platform|
    course = Course.new(title: 'Course Cute Title ' + platform.id.to_s,platform: platform,active: true, abbreviation: 'ABC',intro: 'Hello And Welcome',overview: 'Super cool course!',outline: 'Learn and get rich',intended_audience: 'Students',pdf: 'course_data.pdf',price: 35.9,page_title: 'Course Cute Title',page_description: 'Course Cute Description')
    course.categories << category
    course.save
  end
end
