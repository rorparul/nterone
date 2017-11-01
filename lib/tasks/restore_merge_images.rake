namespace "merge" do
  task :restore_images, [:database, :path] => [:environment] do |t, args|

    @database = args[:database].to_sym
    @path = args[:path].to_sym

    Db::RestoreImagesService.new(@database, @path).call

  end
end