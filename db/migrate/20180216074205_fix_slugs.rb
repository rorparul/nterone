class FixSlugs < ActiveRecord::Migration
  def change
    Category.update_all slug: nil
    Category.find_each(&:save)

    Course.update_all slug: nil
    Course.find_each(&:save)

    LabCourse.update_all slug: nil
    LabCourse.find_each(&:save)

    LmsExam.update_all slug: nil
    LmsExam.find_each(&:save)

    Page.update_all slug: nil
    Page.find_each(&:save)

    Platform.update_all slug: nil
    Platform.find_each(&:save)

    Subject.update_all slug: nil
    Subject.find_each(&:save)

    Video.update_all slug: nil
    Video.find_each(&:save)

    VideoOnDemand.update_all slug: nil
    VideoOnDemand.find_each(&:save)
  end
end
