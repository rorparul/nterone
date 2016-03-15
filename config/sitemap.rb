SitemapGenerator::Sitemap.default_host = "https://www.nterone.com"

SitemapGenerator::Sitemap.create do
  add executives_bios_path
  add instructors_bios_path
  add press_path
  add blog_path
  add industry_path
  add testimonials_path
  add forums_path
  add consulting_path
  add partners_path
  add labs_path
  add platforms_path

  Article.find_each do |article|
    add article_path(article), lastmod: article.updated_at
  end
  Platform.find_each do |platform|
    add platform_path(platform), lastmod: platform.updated_at
  end
  Category.find_each do |category|
    add platform_category_path(category.platform, category), lastmod: category.updated_at
  end
  Subject.find_each do |subject|
    add platform_subject_path(subject.platform, subject), lastmod: subject.updated_at
  end
  Course.find_each do |course|
    add platform_course_path(course.platform, course), lastmod: course.updated_at
  end
  VideoOnDemand.find_each do |video_on_demand|
    add platform_video_on_demand_path(video_on_demand.platform, video_on_demand), lastmod: video_on_demand.updated_at
  end
end
