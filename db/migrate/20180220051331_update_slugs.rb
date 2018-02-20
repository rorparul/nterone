class UpdateSlugs < ActiveRecord::Migration
  def change
    Page.unscoped.update_all slug: nil
    Page.unscoped.find_each(&:save)

    Article.unscoped.update_all slug: nil
    Article.unscoped.find_each(&:save)

    Category.unscoped.update_all slug: nil
    Category.unscoped.find_each(&:save)

    Course.unscoped.update_all slug: nil
    Course.unscoped.find_each(&:save)

    LabCourse.unscoped.update_all slug: nil
    LabCourse.unscoped.find_each(&:save)

    LmsExam.unscoped.update_all slug: nil
    LmsExam.unscoped.find_each(&:save)

    Platform.unscoped.update_all slug: nil
    Platform.unscoped.find_each(&:save)

    Subject.unscoped.update_all slug: nil
    Subject.unscoped.find_each(&:save)

    Video.unscoped.update_all slug: nil
    Video.unscoped.find_each(&:save)

    VideoOnDemand.unscoped.update_all slug: nil
    VideoOnDemand.unscoped.find_each(&:save)
  end
end
