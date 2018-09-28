namespace :update_book_cost do
  desc "Total book cost update of events"
  task :update_total_book_cost_events => :environment do
      Event.where("start_date >=?", "3 Sep 2018").each do |event|
        event.cost_books = event.course.book_cost_per_student.to_i * event.student_count
        event.save
      end  
  end
end
