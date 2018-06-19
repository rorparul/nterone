module SlugValidation
  extend ActiveSupport::Concern

  private

  def format_slug
    self.slug = self.slug.gsub(/[\s|.]/, "-")
  end

  def archive_slug
    self.slug = "#{self.slug}-archived"
  end
end
