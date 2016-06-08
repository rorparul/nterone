require 'ffaker'

FactoryGirl.define do
  sequence :position do
    rand(1..10)
  end

  sequence :title do
    rand(2..5).times.map { FFaker::Lorem.word }.join(' ')
  end

  sequence :url do
    FFaker::Internet.http_url
  end

  sequence :boolean_value do
    [true, false].sample
  end

  sequence :embed_code do
    '<script charset="ISO-8859-1" src="//fast.wistia.com/assets/external/E-v1.js" async></script><div class="wistia_embed wistia_async_j38ihh83m5" style="height:349px;width:620px">&nbsp;</div>)'
  end
end
