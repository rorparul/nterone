# == Schema Information
#
# Table name: events
#
#  id                             :integer          not null, primary key
#  start_date                     :date
#  end_date                       :date
#  format                         :string
#  price                          :decimal(8, 2)    default(0.0)
#  instructor_id                  :integer
#  course_id                      :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  guaranteed                     :boolean          default(FALSE)
#  active                         :boolean          default(TRUE)
#  start_time                     :time
#  end_time                       :time
#  city                           :string
#  state                          :string
#  status                         :string           default("Pending")
#  lab_source                     :string
#  public                         :boolean          default(TRUE)
#  cost_instructor                :decimal(8, 2)    default(0.0)
#  cost_lab                       :decimal(8, 2)    default(0.0)
#  cost_te                        :decimal(8, 2)    default(0.0)
#  cost_facility                  :decimal(8, 2)    default(0.0)
#  cost_books                     :decimal(8, 2)    default(0.0)
#  cost_shipping                  :decimal(8, 2)    default(0.0)
#  partner_led                    :boolean          default(FALSE)
#  time_zone                      :string
#  sent_all_webex_invite          :boolean          default(FALSE)
#  sent_all_course_material       :boolean          default(FALSE)
#  sent_all_lab_credentials       :boolean          default(FALSE)
#  should_remind                  :boolean          default(TRUE)
#  remind_period                  :integer          default(0)
#  reminder_sent                  :boolean          default(FALSE)
#  note                           :text
#  count_weekends                 :boolean          default(FALSE)
#  in_house_note                  :text
#  street                         :string
#  language                       :integer          default(0)
#  calculate_book_costs           :boolean          default(TRUE)
#  autocalculate_instructor_costs :boolean          default(TRUE)
#  resell                         :boolean          default(FALSE)
#  zipcode                        :string
#

module Server
  module Ca
    class Event < ::Event
      extend Base
      establish_connection db_config

      belongs_to :course
    end
  end
end
