require 'rails_helper'

RSpec.describe Db::RestoreImagesService do
  before(:all) do
    database = 'nterone-test-la'.to_sym
    uploads_path = '/media/sf_linux/nterone/la'

    ActiveRecord::Base.establish_connection :test
    begin
        ActiveRecord::Base.connection.execute("DROP DATABASE \"#{database}\";")
    rescue
    end
    ActiveRecord::Base.connection.execute("CREATE DATABASE \"#{database}\" WITH TEMPLATE nterone_test OWNER postgres;")

    ActiveRecord::Base.establish_connection database
    create_list :subject, 3
    create_list :course, 3
    create_list :video_on_demand, 3

    ActiveRecord::Base.establish_connection :test
    expect(Subject.unscoped.count).to eq 0
    expect(Course.unscoped.count).to eq 0
    expect(VideoOnDemand.unscoped.count).to eq 0

    merge_service = Db::MergeService.new database

    merge_service.merge_model(Subject)
    merge_service.merge_model(Course)
    merge_service.merge_model(VideoOnDemand)
    merge_service.merge_model(Image)
    merge_service.post_update
    merge_service.set_origin_region

    @service = Db::RestoreImagesService.new database, uploads_path
    @service.call
  end

  [Subject, Course, VideoOnDemand].each do |model|
    context "for #{model.name}" do
      before do
        ActiveRecord::Base.establish_connection :test
        @object = Image.where(imageable_type: model.name).first.imageable
      end

      it { expect(@object.image).to_not be_nil }
      it { expect(@object.image.file.present?).to be true }
    end
  end
end