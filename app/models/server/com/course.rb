# == Schema Information
#
# Table name: courses
#
#  id                 :integer          not null, primary key
#  title              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  platform_id        :integer
#  active             :boolean          default(TRUE)
#  abbreviation       :string
#  intro              :text
#  overview           :text
#  outline            :text
#  intended_audience  :text
#  pdf                :string
#  video_preview      :text
#  price              :decimal(8, 2)    default(0.0)
#  slug               :string
#  page_title         :string
#  page_description   :text
#  partner_led        :boolean          default(FALSE)
#  heading            :string
#  satellite_viewable :boolean          default(TRUE)
#
# Indexes
#
#  index_courses_on_slug  (slug)
#

module Server
  module Com
    class Course < ::Course
      extend Base
      establish_connection db_config

      belongs_to :platform
    end
  end
end
