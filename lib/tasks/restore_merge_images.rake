namespace "merge" do
  task :restore_images, [:database] => [:environment] do |t, args|

    @database = args[:database].to_sym

    Db::RestoreImagesService.new(@database).call

  end
end