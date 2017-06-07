require "rails_helper"

describe "rake merge:databases", type: :task do
    let(:database) { "nterone-test-la" }

    before(:each) do
        ActiveRecord::Base.establish_connection :test
        ActiveRecord::Base.connection.execute("DROP DATABASE \"#{database}\";")
        ActiveRecord::Base.connection.execute("CREATE DATABASE \"#{database}\" WITH TEMPLATE nterone_test OWNER postgres;")
    end

    it "updates all relations" do
        ActiveRecord::Base.establish_connection database.to_sym
        create(:event)

        ActiveRecord::Base.establish_connection :test
        expect {
            task.execute database: database
        }.to change { Course.count }.by(1)

        expect(Event.last.course).to_not be_nil
    end

    it "updates polymorphic relations" do
        ActiveRecord::Base.establish_connection database.to_sym
        create(:group_item)
        create(:event)

        ActiveRecord::Base.establish_connection :test
        create(:event)

        expect {
            task.execute database: database
        }.to change { GroupItem.count }.by(1)

        expect(GroupItem.last.groupable).to_not be_nil
    end

    it "updates tree relations" do
        ActiveRecord::Base.establish_connection database.to_sym
        parent = create(:user)
        create(:user, parent: parent)

        ActiveRecord::Base.establish_connection :test
        create(:user)

        expect {
            task.execute database: database
        }.to change { User.count }.by(2)

        expect(User.last.parent).to_not be_nil
    end
end