after :video_on_demands do
  lms_student1 = User.find_by(email: 'lms_student1@mail.com')
  lms_student2 = User.find_by(email: 'lms_student2@mail.com')
  lms_manager = User.find_by(email: 'lms_manager@mail.com')

  VideoOnDemand.all.each do |vod|
    AssignedItem.create(assigner: lms_manager, student: lms_student1, item: vod)
    AssignedItem.create(assigner: lms_manager, student: lms_student2, item: vod)
  end
end
