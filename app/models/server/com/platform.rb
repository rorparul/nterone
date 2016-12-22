# == Schema Information
#
# Table name: platforms
#
#  id                 :integer          not null, primary key
#  title              :string
#  created_at         :datetime
#  updated_at         :datetime
#  url                :string
#  slug               :string
#  page_title         :string
#  page_description   :text
#  satellite_viewable :boolean          default(TRUE)
#
# Indexes
#
#  index_platforms_on_slug  (slug)
#

module Server
  module Com
    class Platform < ::Platform
      extend Base
      establish_connection db_config

      has_many :courses
      has_many :events, through: :courses
    end
  end
end
