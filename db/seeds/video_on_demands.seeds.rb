after :categories do
  Category.all.each do |category|
    vod = VideoOnDemand.create(
      platform: category.platform,
      price: 3.0,
      title: 'React.js Ninja',
      abbreviation: 'react.js',
      page_title: 'React.js Ninja',
      page_description: 'This Course will help you to became React.js Ninja',
      active: true,
      lms: true
    )

    CategoryVideoOnDemand.create(video_on_demand: vod, category: category)

    vod2 = VideoOnDemand.create(
      platform: category.platform,
      price: 5.8,
      title: 'Redux Basics',
      abbreviation: 'redux',
      page_title: 'Redux Basics',
      page_description: 'level up your redux knowlidge',
      active: true,
      lms: true
    )

    CategoryVideoOnDemand.create(video_on_demand: vod2, category: category)
  end
end
