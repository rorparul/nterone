# == Schema Information
#
# Table name: tasks
#
#  id            :integer          not null, primary key
#  activity_date :datetime
#  description   :text
#  rep_id        :integer
#  priority      :integer          default(2)
#  subject       :string
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  complete      :boolean          default(FALSE)
#

class Task < ActiveRecord::Base
  # belongs_to :user
end
