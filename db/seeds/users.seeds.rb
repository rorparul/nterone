#users
member = User.create(email: 'member@mail.com', password: 'Password1')
admin = User.create(email: 'super_admin@mail.com', password: 'Password1')

#lms users
lms_student1 = User.create(email: 'lms_student1@mail.com', password: 'Password1')
lms_student2 = User.create(email: 'lms_student2@mail.com', password: 'Password1')
lms_manager = User.create(email: 'lms_manager@mail.com', password: 'Password1')
lms_business = User.create(email: 'lms_business@mail.com', password: 'Password1')

#roles
Role.create(role: 4, user: member)
Role.create(role: 1, user: admin)
Role.create(role: 6, user: lms_student1)
Role.create(role: 6, user: lms_student2)
Role.create(role: 5, user: lms_manager)
Role.create(role: 7, user: lms_business)
