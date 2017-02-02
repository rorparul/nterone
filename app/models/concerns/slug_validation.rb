module SlugValidation
  extend ActiveSupport::Concern

  private

  def format_slug
    self.slug = self.slug.gsub(/[\s|.]/, "-")
  end
end
