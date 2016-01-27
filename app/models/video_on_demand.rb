class VideoOnDemand < ActiveRecord::Base
  belongs_to :platform
  belongs_to :course
  belongs_to :instructor

  has_many :order_items,               as: :orderable
  has_many :orders,                    through: :order_items
  has_many :category_video_on_demands, dependent: :destroy
  has_many :categories,                through: :category_video_on_demands
  has_many :video_modules,             dependent: :destroy
  has_many :videos,                    through: :video_modules
  has_many :users,                     through: :order_items

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
