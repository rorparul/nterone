after :video_on_demands do
  VideoOnDemand.all.each do |vod|
    User.all.each do |user|
      OrderItem.create(orderable: vod, user: user, price: 100)
    end
  end
end
