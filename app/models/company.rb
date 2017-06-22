# == Schema Information
#
# Table name: companies
#
#  id             :integer          not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  title          :string
#  form_type      :integer
#  slug           :string
#  user_id        :integer
#  kind           :string
#  street         :string
#  city           :string
#  state          :string
#  zip_code       :string
#  phone          :string
#  website        :string
#  parent_id      :integer
#  industry_code  :string
#  partner        :boolean          default(FALSE)
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#  sales_force_id :string
#

class Company < ActiveRecord::Base
  extend ActsAsTree::TreeView
  extend ActsAsTree::TreeWalker

  include SearchCop
  include Regions

  acts_as_tree order: 'title'

  belongs_to :user

  has_many :users
  has_many :lab_rentals
  has_many :lab_courses
  has_many :account_opportunities, class_name: 'Opportunity', foreign_key: 'account_id'
  has_many :partner_opportunities, class_name: 'Opportunity', foreign_key: 'partner_id'

	validates :title, presence: true

  before_create :create_slug

  scope :partners, -> { where(kind: 'Channel Partner') }

  search_scope :custom_search do
    attributes :title, :industry_code
    attributes :user => ['user.first_name', 'user.last_name', 'user.email']
  end

  private

  def create_slug
    self.slug = title.downcase.gsub(' ', '-')
  end
end
