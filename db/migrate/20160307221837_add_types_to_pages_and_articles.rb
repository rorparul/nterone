class AddTypesToPagesAndArticles < ActiveRecord::Migration
  def change
    add_column :pages, :static, :boolean, default: false
  end
end
