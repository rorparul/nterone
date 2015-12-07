class SubjectGroup < ActiveRecord::Base
  belongs_to :subject
  belongs_to :group
end
