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
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#  sales_force_id :string
#
# Indexes
#
#  index_companies_on_origin_region  (origin_region)
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

	validates :industry_code, :kind, :title, presence: true

  before_create :create_slug

  after_save :reassign_company_users, if: proc { |model| model.user_id_changed? }
  
  scope :pending, -> { joins(:account_opportunities).where(opportunities: {stage: [10, 50, 75, 90]}) }
  scope :won,     -> { joins(:account_opportunities).where(opportunities: {stage: 100}) }
  scope :waiting, -> { joins(:account_opportunities).where(opportunities: {waiting: true}) }
  scope :lost,    -> { joins(:account_opportunities).where(opportunities: {stage: 0}) }

  scope :partners, -> { where(kind: 'Channel Partner') }

  search_scope :custom_search do
    attributes :title, :industry_code
  end

  def full_address
    [street, city, state, zip_code].compact.join(", ")
  end

  def children_and_self
    ids = children.map(&:id) + [id]
    Company.where(id: ids)
  end

  def self.companies_with_amount(opportunities)
    companies = Company.where(id: opportunities.map(&:account_id).reject(&:blank?).uniq)
    companies.select{|company| 
                      Opportunity.get_company_total_amount(opportunities, company.id) > 0
                    }
  end

  private

  def reassign_company_users
    users.update_all(parent_id: user.id)
  end

  def create_slug
    self.slug = title.downcase.gsub(' ', '-')
  end
end
