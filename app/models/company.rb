# == Schema Information
#
# Table name: companies
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  title         :string
#  form_type     :integer
#  slug          :string
#  user_id       :integer
#  kind          :string
#  street        :string
#  city          :string
#  state         :string
#  zip_code      :string
#  phone         :string
#  website       :string
#  parent_id     :integer
#  industry_code :string
#  partner       :boolean          default(FALSE)
#

class Company < ActiveRecord::Base
  has_many :users
  has_many :lab_rentals
  has_many :lab_courses

	validates :title, presence: true

  before_create :create_slug

  private

  def create_slug
    self.slug = self.title.downcase.gsub(' ', '-')
  end
end
