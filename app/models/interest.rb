# == Schema Information
#
# Table name: interests
#
#  id                               :integer          not null, primary key
#  user_id                          :integer
#  data_center                      :boolean
#  collaboration                    :boolean
#  network                          :boolean
#  security                         :boolean
#  associate_level_certification    :boolean
#  professional_level_certification :boolean
#  expert_level_certification       :boolean
#  other                            :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#

class Interest < ActiveRecord::Base
  belongs_to :user
end
