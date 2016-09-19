namespace :migrate_instructors do
  task :all => :environment do
    Instructor.all.each do |instructor|
      user = User.find_by('lower(email) = ?', instructor.email.downcase)

      if user
        user.update_attributes(
          about: instructor.biography
        )
      else
        next if instructor.email.blank?

        user = User.new(
          first_name:            instructor.first_name,
          last_name:             instructor.last_name,
          email:                 instructor.email,
          password:              'password',
          password_confirmation: 'password',
          about:                 instructor.biography
        )

        user.skip_invitation

        user.save(validate: false)
      end

      Role.create(user_id: user.id, role: 7)

      Event.where.not(instructor_id: nil).each do |event|
        old_instructor = Instructor.find(event.instructor_id)
        new_instructor = User.find_by('lower(email) = ?', old_instructor.email.downcase)

        event.update_attributes(instructor_id: new_instructor.try(:id))
      end
    end
  end
end
