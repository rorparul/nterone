# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.nterone.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  add executives_bios_path
  add instructors_bios_path
  add press_path
  PressRelease.find_each do |press_release|
    add press_release_path(press_release), lastmod: press_release.updated_at
  end
  add blog_path
  BlogPost.find_each do |blog_post|
    add blog_post_path(blog_post), lastmod: blog_post.updated_at
  end
  add industry_path
  IndustryArticle.find_each do |industry_article|
    add industry_article_path(industry_article), lastmod: industry_article.updated_at
  end
  add platforms_path
  Platform.find_each do |platform|
    add platform_path(platform), lastmod: platform.updated_at
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
  add testimonials_path
  add forums_path
  add consulting_path
  add partners_path
  add labs_path
end
