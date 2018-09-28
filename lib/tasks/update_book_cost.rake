namespace :update_book_cost do
  desc "Total book cost update of events"
  task :update_total_book_cost_events => :environment do
      Event.where("start_date >=?", "3 Sep 2018").each do |event|
        event.book_cost_per_student = event.course.try(:book_cost_per_student)
        event.save
      end
  end
end
