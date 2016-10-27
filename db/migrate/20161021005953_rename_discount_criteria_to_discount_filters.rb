class RenameDiscountCriteriaToDiscountFilters < ActiveRecord::Migration
  def change
    rename_table :discount_criteria, :discount_filters
  end
end
