# == Schema Information
#
# Table name: video_on_demands
#
#  id                :integer          not null, primary key
#  course_id         :integer
#  instructor_id     :integer
#  level             :string
#  price             :decimal(8, 2)    default(0.0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  platform_id       :integer
#  title             :string
#  abbreviation      :string
#  slug              :string
#  page_title        :string
#  page_description  :text
#  intro             :text
#  overview          :text
#  outline           :text
#  intended_audience :text
#  partner_led       :boolean          default(FALSE)
#  active            :boolean          default(TRUE)
#  lms               :boolean          default(FALSE)
#  heading           :string
#
# Indexes
#
#  index_video_on_demands_on_slug  (slug)
#

class VideoOnDemand < ActiveRecord::Base
  extend FriendlyId
  include Imageable

  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [
      :abbreviation,
      [:abbreviation, :title]
    ]
  end

  belongs_to :platform
  belongs_to :course #TODO remove after transfer
  belongs_to :instructor

  has_many :order_items,               as: :orderable
  has_many :orders,                    through: :order_items
  has_many :category_video_on_demands, dependent: :destroy
  has_many :categories,                through: :category_video_on_demands
  has_many :video_modules,             dependent: :destroy
  has_many :videos,                    through: :video_modules
  has_many :users,                     through: :order_items

  has_one  :image, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :image

  accepts_nested_attributes_for :video_modules, reject_if: :all_blank, allow_destroy: true

  before_destroy :ensure_not_purchased_or_in_cart

  validates :categories, :title, :abbreviation, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates_associated :categories

  def full_title
    if abbreviation.present?
      "#{abbreviation}: #{title}"
    else
      title
    end
  end

  private

  def ensure_not_purchased_or_in_cart
    if users.empty?
      return true
    else
      errors.add(:base, 'Order Items present')
      return false
    end
  end
end
