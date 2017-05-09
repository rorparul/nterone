after :users do
  lms_student1 = User.find_by(email: 'lms_student1@mail.com')
  lms_student2 = User.find_by(email: 'lms_student2@mail.com')
  lms_manager = User.find_by(email: 'lms_manager@mail.com')

  LmsManagedStudent.create(user: lms_student1, manager: lms_manager)
  LmsManagedStudent.create(user: lms_student2, manager: lms_manager)
end
