# == Schema Information
#
# Table name: public_featured_events
#
#  id                  :integer          not null, primary key
#  full_title          :string
#  platform_course_url :string
#  start_date          :date
#  end_date            :date
#  length              :integer
#  format              :string
#  language            :string
#  city                :string
#  state               :string
#  street              :string
#  price               :decimal(8, 2)    default(0.0)
#  video_preview       :text
#  link_to_cart        :string
#  pdf_url             :string
#  platform_id         :integer
#  platform_title      :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  host                :string
#  event_id            :integer
#

class PublicFeaturedEvent < ActiveRecord::Base
  belongs_to :cloned_event, class_name: "Event", foreign_key: "event_id"
end