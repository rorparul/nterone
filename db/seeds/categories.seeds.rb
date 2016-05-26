after :platforms do
    Platform.all.each do |platform|
      platform.categories.create([{ title: 'Basics' }])
    end
end
