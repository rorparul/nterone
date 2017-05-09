after :video_modules do
  embed_code = '<script charset="ISO-8859-1" src="//fast.wistia.com/assets/external/E-v1.js" async></script><div class="wistia_embed wistia_async_j38ihh83m5" style="height:349px;width:620px">&nbsp;</div>'

  VideoModule.all.each do |video_module|
    Video.create(title: 'Using PropTypes', free: true, position: 1, embed_code: embed_code, video_module: video_module)
    Video.create(title: 'Managing state with Redux', free: false, position: 2, embed_code: embed_code, video_module: video_module)
    Video.create(title: 'Testing React Components', free: false, position: 3, embed_code: embed_code, video_module: video_module)
    Video.create(title: 'Using Immutable Data Structures', free: false, position: 4, embed_code: embed_code, video_module: video_module)
    Video.create(title: 'Loading Data for Component', free: false, position: 5, embed_code: embed_code, video_module: video_module)
  end
end
