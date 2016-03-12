namespace :convert_articles do
  desc "Converting"
  task :process => :environment do
    PressRelease.all.each do |item|
      article = Article.new
      old_attributes = item.attributes.except("id")
      article.update_attributes(old_attributes)
      article.kind = "Press Release"
      article.save
    end
    BlogPost.all.each do |item|
      article = Article.new
      old_attributes = item.attributes.except("id")
      article.update_attributes(old_attributes)
      article.kind = "Blog Post"
      article.save
    end
    IndustryArticle.all.each do |item|
      article = Article.new
      old_attributes = item.attributes.except("id")
      article.update_attributes(old_attributes)
      article.kind = "Industry Article"
      article.save
    end
  end
end
